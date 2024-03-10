import postgres from "postgres";
import { products } from "./product";
import { shelves } from "./shelf";
import { drizzle } from "drizzle-orm/postgres-js";
import { shelfLogs } from "./shelf-logs";

const schema = {
	products,
	shelves,
	shelfLogs,
};

const queryClient = postgres(process.env.POSTGRES_URL!);
const database = drizzle(queryClient, { schema });

export default database;
