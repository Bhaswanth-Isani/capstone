import { ZodString, z, type ZodEffects } from "zod";

const IDSchema = (prefix: string): ZodEffects<ZodString, string, string> => {
	return z.string().refine((val) => {
		const id = val.split("_");

		if (id.length !== 2) {
			return false;
		}

		return (
			id[0] === prefix &&
			z
				.string({ errorMap: (_, __) => ({ message: "ID is invalid." }) })
				.uuid({ message: "ID is invalid." })
				.safeParse(id[1]).success
		);
	});
};

export const ProductIDSchema = IDSchema("product");
export const ShelfIDSchema = IDSchema("shelf");
