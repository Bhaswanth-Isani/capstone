import { decimal, integer, pgTable, text, varchar } from "drizzle-orm/pg-core";
import { products } from "./product";

export const shelves = pgTable("shelves", {
	id: varchar("id").primaryKey(),
	name: text("name").notNull(),
	productID: varchar("product_id").references(() => products.id, {
		onDelete: "set null",
		onUpdate: "cascade",
	}),
	quantity: integer("quantity").default(0).notNull(),
	size: decimal("size").notNull(),
});
