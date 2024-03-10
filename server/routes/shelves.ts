import { z } from "zod";
import { ProductIDSchema } from "../core/id-schema";
import { Hono } from "hono";
import database from "../database/database";
import { shelves } from "../database/shelf";
import { zValidator } from "@hono/zod-validator";
import { eq } from "drizzle-orm";
import { io } from "..";

const ShelfSchema = z.object({
	id: z.string(),
	name: z.string().min(1),
	productID: ProductIDSchema.nullable(),
	size: z.number().positive(),
	quantity: z.number().gte(0),
});

const app = new Hono();

app.get("/", async (c) => {
	const shelves = await database.query.shelves.findMany();
	return c.json(
		shelves.map((shelf) => ({ ...shelf, size: parseFloat(shelf.size) }))
	);
});

app.post("/", zValidator("json", ShelfSchema), async (c) => {
	const { id, name, productID, size, quantity } = c.req.valid("json");
	const [shelf] = await database
		.insert(shelves)
		.values({
			id,
			name,
			productID,
			size: size.toString(),
			quantity: quantity,
		})
		.returning();
	io.emit("shelf:save", {
		shelf: {
			...shelf,
			size: parseFloat(shelf.size),
		},
	});
	return c.json({
		...shelf,
		size: parseFloat(shelf.size),
	});
});

app.patch(
	"/:id",
	zValidator("param", z.object({ id: z.string() })),
	zValidator("json", ShelfSchema),
	async (c) => {
		const { id } = c.req.valid("param");
		const { name, productID, size, quantity } = c.req.valid("json");
		const [shelf] = await database
			.update(shelves)
			.set({ name, productID, size: size.toString(), quantity })
			.where(eq(shelves.id, id))
			.returning();
		io.emit("shelf:save", {
			shelf: {
				...shelf,
				size: parseFloat(shelf.size),
			},
		});
		return c.json({
			...shelf,
			size: parseFloat(shelf.size),
		});
	}
);

app.delete(
	"/:id",
	zValidator("param", z.object({ id: z.string() })),
	async (c) => {
		const { id } = c.req.valid("param");
		const shelf = await database.delete(shelves).where(eq(shelves.id, id));
		io.emit("shelf:delete", { id });
		return c.json(shelf);
	}
);

export default app;
