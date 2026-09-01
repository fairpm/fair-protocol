import remarkDirective from 'remark-directive';
import remarkFrontmatter from 'remark-frontmatter';
import remarkGfm from 'remark-gfm';
import remarkMdx from 'remark-mdx';

export default {
  plugins: [
    remarkFrontmatter,
    remarkGfm,
    remarkDirective,
    remarkMdx,
  ],
};