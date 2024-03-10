CREATE TABLE IF NOT EXISTS "products" (
	"id" varchar PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"size" numeric NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "shelf_logs" (
	"id" varchar PRIMARY KEY NOT NULL,
	"timestamp" timestamp NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "shelves" (
	"id" varchar PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"product_id" varchar,
	"quantity" integer DEFAULT 0 NOT NULL,
	"size" numeric NOT NULL
);
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "shelves" ADD CONSTRAINT "shelves_product_id_products_id_fk" FOREIGN KEY ("product_id") REFERENCES "products"("id") ON DELETE set null ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
