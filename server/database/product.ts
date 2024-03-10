import { decimal, pgTable, text, varchar } from "drizzle-orm/pg-core";

export const products = pgTable("products", {
	id: varchar("id").primaryKey(),
	name: text("name").notNull(),
	size: decimal("size").notNull(),
});
