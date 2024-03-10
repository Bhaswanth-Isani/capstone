import { Hono } from "hono";
import database from "../database/database";
import { z } from "zod";
import { ProductIDSchema } from "../core/id-schema";
import { zValidator } from "@hono/zod-validator";
import { products } from "../database/product";
import { eq } from "drizzle-orm";
import { io } from "..";

const ProductSchema = z.object({
	id: ProductIDSchema,
	name: z.string().min(1),
	size: z.number().positive(),
});

const app = new Hono();

app.get("/", async (c) => {
	const products = await database.query.products.findMany();
	return c.json(
		products.map((product) => ({ ...product, size: parseFloat(product.size) }))
	);
});

app.post("/", zValidator("json", ProductSchema), async (c) => {
	const { id, name, size } = c.req.valid("json");
	const [product] = await database
		.insert(products)
		.values({
			id,
			name,
			size: size.toString(),
		})
		.returning();
	io.emit("product:save", {
		product: {
			...product,
			size: parseFloat(product.size),
		},
	});
	return c.json({
		...product,
		size: parseFloat(product.size),
	});
});

app.patch(
	"/:id",
	zValidator("param", z.object({ id: ProductIDSchema })),
	zValidator("json", ProductSchema),
	async (c) => {
		const { id } = c.req.valid("param");
		const { name } = c.req.valid("json");
		const [product] = await database
			.update(products)
			.set({ name })
			.where(eq(products.id, id))
			.returning();
		io.emit("product:save", {
			product: {
				...product,
				size: parseFloat(product.size),
			},
		});
		return c.json({
			...product,
			size: parseFloat(product.size),
		});
	}
);

app.delete(
	"/:id",
	zValidator("param", z.object({ id: ProductIDSchema })),
	async (c) => {
		const { id } = c.req.valid("param");
		const product = await database.delete(products).where(eq(products.id, id));
		io.emit("product:delete", { id });
		return c.json(product);
	}
);

export default app;
