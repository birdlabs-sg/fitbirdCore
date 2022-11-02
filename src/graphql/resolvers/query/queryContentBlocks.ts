import { QueryGetContentBlocksArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";

export async function getContentBlocksResolver(
  _: unknown,
  { content_block_type }: QueryGetContentBlocksArgs,
  context: AppContext
) {
  const prisma = context.dataSources.prisma;
  return await prisma.contentBlock.findMany({
    where: {
      content_block_type: content_block_type,
    },
  });
}
