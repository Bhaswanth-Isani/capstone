import { pgTable, timestamp, varchar } from "drizzle-orm/pg-core";

export const shelfLogs = pgTable("shelf_logs", {
	id: varchar("id").primaryKey(),
	timestamp: timestamp("timestamp").notNull(),
});
