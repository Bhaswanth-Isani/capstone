import type { Config } from "drizzle-kit";

export default {
	schema: "./database/**/*",
	out: "./migrations",
	driver: "pg",
	dbCredentials: {
		connectionString: "postgresql://postgres:123456789@localhost:5432/capstone",
		ssl: true,
	},
} satisfies Config;
