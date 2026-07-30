# GitHub Pages + Supabase 共享账本

不使用 Render，不需要绑卡。GitHub Pages 托管网页，Supabase 保存数据和处理两人登录。

## Supabase 一次性配置

1. 创建免费 Supabase 项目，地区优先 Singapore。
2. 在 SQL Editor 新建查询，完整粘贴并执行 `supabase/schema.sql`。
3. 在 Authentication > Providers > Email 确认 Email 已启用；保留邮箱确认也可以。
4. 在 Connect 复制 Project URL 和 `anon public` key，填入 `docs/config.js` 的两个占位符。不要使用 `service_role` key。

## 部署到 GitHub Pages

1. 将 `docs`、`supabase` 和本 README 上传到仓库。
2. GitHub 仓库 Settings > Pages：Source 选 Deploy from a branch，Branch 选 main，Folder 选 `/docs`，保存。
3. 若仓库是私有且 Pages 不可选，将仓库改为 Public。`config.js` 里的 anon key 可以公开，数据由 Supabase 的登录和行级权限保护。

## 首次使用

打开 GitHub Pages 地址，分别用施展和刘馨遥各自的邮箱、密码注册并登录。注册后如需要邮件确认，先确认邮件再登录。两个已登录用户会共享同一份账本。

## 清理

使用结束后，在 Supabase 删除项目，在 GitHub Pages 关闭 Pages。
