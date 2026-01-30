# XMall 商城项目

一个基于 Vue 3 + Vant UI + Express + MySQL 的移动端商城系统。本项目由 **Gemini 3 Pro** 辅助完成。

## 🚀 功能特性

- **用户系统**
  - 登录 / 注册 / 找回密码
  - 个人资料修改（头像、昵称）
  - 账号安全设置（修改手机号、修改密码）
- **商品系统**
  - 首页推荐与商品展示
  - 商品分类浏览（一级/二级分类）
  - 商品详情页
  - 搜索功能（支持关键词搜索）
- **购物车**
  - 加入购物车
  - 购物车管理（选中、删除、清空）
  - 结算
- **订单系统**
  - 订单列表（待付款、待发货、待收货、待评价）
  - 订单详情
  - 退款/售后管理
- **其他功能**
  - 收货地址管理
  - 商品收藏
  - 浏览历史
  - 消息中心（客服聊天）

## 🛠️ 技术栈

- **前端**: Vue 3, Vant 4, Vue Router, Pinia, Axios, Less
- **后端**: Node.js, Express, MySQL
- **数据库**: MySQL 5.7+

## 📦 数据库配置

本项目提供了一个完整的数据库初始化脚本 `database/xmall.sql`，包含了表结构和演示数据。

1.  **创建数据库**: 确保你的 MySQL 服务已启动。
2.  **导入数据**:
    - 使用 Navicat / DBeaver 等工具连接本地 MySQL。
    - 运行 `database/xmall.sql` 文件。
    - 或者使用命令行：
      ```bash
      mysql -u root -p xmall_db < database/xmall.sql
      ```
3.  **连接配置**:
    - 默认数据库配置位于 `server/db.js`。
    - **Host**: localhost
    - **User**: root
    - **Password**: root
    - **Database**: xmall_db

## 🏃‍♂️ 运行项目

### 1. 启动后端服务

```bash
cd server
npm install
node index.js
```
服务将在 `http://localhost:3000` 启动。

### 2. 启动前端服务

```bash
# 回到根目录
cd ..
npm install
npm run dev
```
访问 `http://localhost:5173` (或终端显示的地址) 即可体验。

## 📄 License

MIT License

Copyright (c) 2026 Kifranei

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

*This project was developed with the assistance of **Gemini 3 Pro**.*
