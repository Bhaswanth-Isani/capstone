import { drizzle } from "drizzle-orm/postgres-js";
import { migrate } from "drizzle-orm/postgres-js/migrator";
import postgres from "postgres";

const migrationClient = postgres(process.env.POSTGRES_URL!, { max: 1 });
migrate(drizzle(migrationClient), { migrationsFolder: "./migrations" })
	.then(() => {
		console.log("Successfully pushed");
		migrationClient.end();
	})
	.catch((error) => {
		console.log(error);
		migrationClient.end();
	});
