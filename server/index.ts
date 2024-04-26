import { Hono } from "hono";
import { logger } from "hono/logger";
import { Server } from "socket.io";
import { zValidator } from "@hono/zod-validator";
import { z } from "zod";
import database from "./database/database";
import { eq, lte } from "drizzle-orm";
import { shelves } from "./database/shelf";
import { products } from "./database/product";
import { createClient } from "@clickhouse/client-web";
import productsRoute from "./routes/product";
import shelvesRoute from "./routes/shelves";
import { shelfLogs } from "./database/shelf-logs";
import { ProductIDSchema, ShelfIDSchema } from "./core/id-schema";

const app = new Hono();

const clickhouse = createClient({
	host: "http://clickhouse:8123",
	database: "capstone",
});

app.use(logger());
app.all("/health", (c) => c.text("API is healthy"));

app.route("/products", productsRoute);
app.route("/shelves", shelvesRoute);

app.post(
	"/logs/:id",
	zValidator("param", z.object({ id: ShelfIDSchema })),
	async (c) => {
		const { id } = c.req.valid("param");
		await database
			.insert(shelfLogs)
			.values({ id, timestamp: new Date() })
			.onConflictDoUpdate({
				target: shelfLogs.id,
				set: { timestamp: new Date() },
			});

		const malfunctionedShelves = await database.query.shelfLogs.findMany();

		if (malfunctionedShelves.length > 0) {
			io.emit("shelf:malfunction", { shelves: malfunctionedShelves });
		}

		return c.json({});
	}
);

app.delete(
	"/logs/:id",
	zValidator("param", z.object({ id: ShelfIDSchema })),
	async (c) => {
		const { id } = c.req.valid("param");

		await database.delete(shelfLogs).where(eq(shelfLogs.id, id));

		io.emit("shelf:malfunction-delete", { id });
		return c.json({});
	}
);

app.get(
	"/quantity/:id",
	zValidator("param", z.object({ id: ProductIDSchema })),
	async (c) => {
		const { id } = c.req.valid("param");

		console.log(id);

		const finalDates = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
		const quantities: number[] = [];

		for (let i = 0; i < finalDates.length; i++) {
			const result = await clickhouse.query({
				query: `SELECT SUM(quantity) AS quantity FROM product_logs WHERE product_id = '${id}' AND created_at BETWEEN toDate('2024-${
					i + 1
				}-01') AND toDate('2024-${i + 1}-${finalDates[i]}')`,
				format: "JSON",
			});

			const quantity = await result.json();
			quantities.push(parseInt((quantity as any)["data"][0]["quantity"]));
		}

		return c.json(quantities);
	}
);

app.post(
	"/change/:id",
	zValidator(
		"json",
		z.object({
			quantity: z.number(),
			type: z.enum(["weight", "distance"]),
		})
	),
	zValidator("param", z.object({ id: ShelfIDSchema })),
	async (c) => {
		const { quantity, type } = c.req.valid("json");
		const { id: shelfID } = c.req.valid("param");

		const shelf = await database.query.shelves.findFirst({
			where: eq(shelves.id, shelfID),
		});

		if (!shelf) {
			return c.json({ error: "Shelf not found" }, 404);
		}

		if (!shelf.productID) {
			return c.json({ error: "Shelf is not configured" }, 400);
		}

		const product = await database.query.products.findFirst({
			where: eq(products.id, shelf.productID),
		});

		if (!product) {
			return c.json({ error: "Product not found" }, 404);
		}

		let updatedQuantity: number;

		if (type === "weight") {
			updatedQuantity = quantity / parseFloat(product.size);
			await database
				.update(shelves)
				.set({ quantity: updatedQuantity })
				.where(eq(shelves.id, shelfID));
		} else {
			updatedQuantity =
				(parseFloat(shelf.size) - quantity) / parseFloat(product.size);
			await database
				.update(shelves)
				.set({ quantity: updatedQuantity })
				.where(eq(shelves.id, shelfID));
		}

		const returnShelf = await database.query.shelves.findFirst({
			where: eq(shelves.id, shelfID),
		});

		io.emit("shelf:save", {
			shelf: { ...returnShelf, size: parseFloat(returnShelf!.size) },
		});

		if (shelf.quantity - updatedQuantity > 0) {
			await clickhouse.insert({
				table: "product_logs",
				values: [
					{
						shelf_id: shelf.id,
						product_id: shelf.productID,
						quantity: shelf.quantity - updatedQuantity,
					},
				],
				format: "JSON",
			});
		}

		return c.json({ message: "Updated" });
	}
);

export const io = new Server();

io.on("connection", (socket) => {
	console.log("a user connected");
	socket.on("disconnect", () => {
		console.log("user disconnected");
	});
});

io.listen(5197);

export default {
	port: 5179,
	fetch: app.fetch,
};
