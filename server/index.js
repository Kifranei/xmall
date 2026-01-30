const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const db = require('./db');

const app = express();
const port = 3000;

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// --- 初始化额外表结构 (收藏 & 历史) ---
const initExtraTables = async () => {
  try {
    const createFavorites = `
      CREATE TABLE IF NOT EXISTS \`favorites\` (
        \`id\` bigint(20) NOT NULL AUTO_INCREMENT,
        \`user_id\` bigint(20) NOT NULL,
        \`product_id\` bigint(20) NOT NULL,
        \`created_at\` datetime DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (\`id\`),
        UNIQUE KEY \`uk_user_product\` (\`user_id\`, \`product_id\`)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `;
    const createHistory = `
      CREATE TABLE IF NOT EXISTS \`history\` (
        \`id\` bigint(20) NOT NULL AUTO_INCREMENT,
        \`user_id\` bigint(20) NOT NULL,
        \`product_id\` bigint(20) NOT NULL,
        \`updated_at\` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (\`id\`),
        UNIQUE KEY \`uk_user_product\` (\`user_id\`, \`product_id\`)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `;
    await db.query(createFavorites);
    await db.query(createHistory);
    console.log('Extra tables initialized');
  } catch (error) {
    console.error('Init tables error:', error);
  }
};
initExtraTables();

// 获取分类列表
app.get('/api/categories', async (req, res) => {
  try {
    // 获取一级分类
    const [rows] = await db.query('SELECT * FROM categories WHERE parent_id = 0 ORDER BY sort_order');
    
    // 简单起见，这里先返回一级分类，如果需要树状结构可以递归查询或前端组装
    // 为了配合前端 Search.vue 的逻辑，我们需要构建一下数据结构
    // 实际上 Search.vue 目前是硬编码的，我们稍后会修改 Search.vue 来适配接口
    res.json({
      code: 0,
      data: rows,
      message: 'success'
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ code: 500, message: 'Internal Server Error' });
  }
});

// 获取分类下的子分类 (根据 parent_id)
app.get('/api/categories/sub', async (req, res) => {
    const { parentId } = req.query;
    try {
        const [rows] = await db.query('SELECT * FROM categories WHERE parent_id = ?', [parentId]);
        res.json({
            code: 0,
            data: rows,
            message: 'success'
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ code: 500, message: 'Internal Server Error' });
    }
});

// 获取商品列表
app.get('/api/products', async (req, res) => {
  const { page = 1, pageSize = 10, keyword } = req.query;
  const offset = (page - 1) * pageSize;
  
  try {
    let sql = 'SELECT * FROM products WHERE status = 1';
    const params = [];

    if (keyword) {
      sql += ' AND name LIKE ?';
      params.push(`%${keyword}%`);
    }

    sql += ' ORDER BY created_at DESC LIMIT ? OFFSET ?';
    params.push(parseInt(pageSize), parseInt(offset));

    const [rows] = await db.query(sql, params);
    
    // 获取总数
    let countSql = 'SELECT COUNT(*) as total FROM products WHERE status = 1';
    const countParams = [];
    if (keyword) {
      countSql += ' AND name LIKE ?';
      countParams.push(`%${keyword}%`);
    }
    const [countRows] = await db.query(countSql, countParams);
    
    res.json({
      code: 0,
      data: {
        list: rows,
        total: countRows[0].total
      },
      message: 'success'
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ code: 500, message: 'Internal Server Error' });
  }
});

// 获取商品详情
app.get('/api/products/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [rows] = await db.query('SELECT * FROM products WHERE id = ?', [id]);
    if (rows.length > 0) {
      res.json({
        code: 0,
        data: rows[0],
        message: 'success'
      });
    } else {
      res.status(404).json({ code: 404, message: 'Product not found' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ code: 500, message: 'Internal Server Error' });
  }
});

// --- 收货地址 API ---

// 获取地址列表
app.get('/api/address', async (req, res) => {
  // 暂时写死 user_id = 1，实际应从 token 解析
  const userId = 1;
  try {
    const [rows] = await db.query('SELECT * FROM addresses WHERE user_id = ?', [userId]);
    // 转换字段以适配 Vant AddressList 组件
    const list = rows.map(item => ({
      id: item.id,
      name: item.name,
      tel: item.tel,
      address: `${item.province}${item.city}${item.county} ${item.address_detail}`,
      isDefault: item.is_default === 1,
      // 保存原始数据供编辑使用
      province: item.province,
      city: item.city,
      county: item.county,
      addressDetail: item.address_detail,
      areaCode: item.area_code // 如果有的话
    }));
    res.json({ code: 0, data: list, message: 'success' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ code: 500, message: 'Internal Server Error' });
  }
});

// 获取单个地址
app.get('/api/address/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [rows] = await db.query('SELECT * FROM addresses WHERE id = ?', [id]);
    if (rows.length > 0) {
      const item = rows[0];
      const address = {
        id: item.id,
        name: item.name,
        tel: item.tel,
        province: item.province,
        city: item.city,
        county: item.county,
        addressDetail: item.address_detail,
        isDefault: item.is_default === 1,
      };
      res.json({ code: 0, data: address, message: 'success' });
    } else {
      res.status(404).json({ code: 404, message: 'Address not found' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ code: 500, message: 'Internal Server Error' });
  }
});

// 新增地址
app.post('/api/address', async (req, res) => {
  const userId = 1;
  const { name, tel, province, city, county, addressDetail, isDefault } = req.body;
  
  const conn = await db.getConnection();
  try {
    await conn.beginTransaction();

    // 如果设为默认，先把其他的取消默认
    if (isDefault) {
      await conn.query('UPDATE addresses SET is_default = 0 WHERE user_id = ?', [userId]);
    }

    const [result] = await conn.query(
      'INSERT INTO addresses (user_id, name, tel, province, city, county, address_detail, is_default) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      [userId, name, tel, province, city, county, addressDetail, isDefault ? 1 : 0]
    );

    await conn.commit();
    res.json({ code: 0, data: { id: result.insertId }, message: 'success' });
  } catch (error) {
    await conn.rollback();
    console.error(error);
    res.status(500).json({ code: 500, message: 'Internal Server Error' });
  } finally {
    conn.release();
  }
});

// 修改地址
app.put('/api/address/:id', async (req, res) => {
  const userId = 1;
  const { id } = req.params;
  const { name, tel, province, city, county, addressDetail, isDefault } = req.body;

  const conn = await db.getConnection();
  try {
    await conn.beginTransaction();

    if (isDefault) {
      await conn.query('UPDATE addresses SET is_default = 0 WHERE user_id = ?', [userId]);
    }

    await conn.query(
      'UPDATE addresses SET name=?, tel=?, province=?, city=?, county=?, address_detail=?, is_default=? WHERE id=? AND user_id=?',
      [name, tel, province, city, county, addressDetail, isDefault ? 1 : 0, id, userId]
    );

    await conn.commit();
    res.json({ code: 0, message: 'success' });
  } catch (error) {
    await conn.rollback();
    console.error(error);
    res.status(500).json({ code: 500, message: 'Internal Server Error' });
  } finally {
    conn.release();
  }
});

// 删除地址
app.delete('/api/address/:id', async (req, res) => {
  const { id } = req.params;
  try {
    await db.query('DELETE FROM addresses WHERE id = ?', [id]);
    res.json({ code: 0, message: 'success' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ code: 500, message: 'Internal Server Error' });
  }
});

// --- 订单 API ---

// 获取订单列表
app.get('/api/orders', async (req, res) => {
  const userId = 1;
  const { status } = req.query; // 0:全部 1:待付款 ...
  
  try {
    let sql = 'SELECT * FROM orders WHERE user_id = ?';
    const params = [userId];

    // 假设 status=0 是全部，前端传过来的 status 映射可能需要调整
    // 这里简单处理：如果 status 存在且不为 '0' (全部)，则加条件
    if (status && status !== '0') {
        // 注意：前端 tab 索引和数据库状态值的映射
        // 数据库: 0:待付款 1:待发货 2:待收货 3:已完成
        // 前端 Tab: 0:全部 1:待付款 2:待发货 3:待收货 4:待评价
        // 需要做个映射
        const statusMap = {
            '1': 0, // 待付款
            '2': 1, // 待发货
            '3': 2, // 待收货
            '4': 3, // 已完成/待评价
            '5': 4  // 退款/售后 (已取消)
        };
        if (statusMap[status] !== undefined) {
            sql += ' AND status = ?';
            params.push(statusMap[status]);
        }
    }
    
    sql += ' ORDER BY created_at DESC';

    const [orders] = await db.query(sql, params);

    // 获取每个订单的商品项
    for (let order of orders) {
      const [items] = await db.query('SELECT * FROM order_items WHERE order_id = ?', [order.id]);
      order.items = items;
    }

    res.json({ code: 0, data: orders, message: 'success' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ code: 500, message: 'Internal Server Error' });
  }
});

// 获取订单详情
app.get('/api/orders/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [orders] = await db.query('SELECT * FROM orders WHERE id = ?', [id]);
    if (orders.length > 0) {
      const order = orders[0];
      const [items] = await db.query('SELECT * FROM order_items WHERE order_id = ?', [order.id]);
      order.items = items;
      res.json({ code: 0, data: order, message: 'success' });
    } else {
      res.status(404).json({ code: 404, message: 'Order not found' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ code: 500, message: 'Internal Server Error' });
  }
});

// --- 用户 API ---

// 更新用户信息
app.put('/api/user', async (req, res) => {
  const userId = 1;
  const { nickname, avatar } = req.body;
  try {
    // 检查 users 表中是否有该用户，如果没有则插入（为了模拟数据）
    // 注意：实际项目中应该在注册时创建用户
    const [existing] = await db.query('SELECT * FROM users WHERE id = ?', [userId]);
    if (existing.length === 0) {
        await db.query('INSERT INTO users (id, nickname, avatar, username) VALUES (?, ?, ?, ?)', [userId, nickname, avatar, 'admin']);
    } else {
        await db.query('UPDATE users SET nickname = ?, avatar = ? WHERE id = ?', [nickname, avatar, userId]);
    }
    
    // 返回更新后的用户信息
    const [users] = await db.query('SELECT * FROM users WHERE id = ?', [userId]);
    
    // 构造前端需要的格式
    const user = users[0];
    const userInfo = {
        nickname: user.nickname,
        avatar: user.avatar,
        userId: user.id.toString(), // 确保 ID 转字符串
        username: user.username,
        balance: 100.00, // 模拟数据
        points: 520,
        coupons: 3
    };
    
    res.json({ code: 0, data: userInfo, message: '更新成功' });
  } catch (error) {
    console.error(error);
    // 如果是表不存在错误，尝试创建表（容错处理）
    if (error.code === 'ER_NO_SUCH_TABLE') {
        try {
            await db.query(`
                CREATE TABLE IF NOT EXISTS \`users\` (
                  \`id\` bigint(20) NOT NULL AUTO_INCREMENT,
                  \`username\` varchar(50) NOT NULL,
                  \`password\` varchar(100) DEFAULT NULL,
                  \`nickname\` varchar(50) DEFAULT NULL,
                  \`avatar\` varchar(255) DEFAULT NULL,
                  \`mobile\` varchar(20) DEFAULT NULL,
                  \`created_at\` datetime DEFAULT CURRENT_TIMESTAMP,
                  PRIMARY KEY (\`id\`),
                  UNIQUE KEY \`uk_username\` (\`username\`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
            `);
            // 重新尝试更新/插入
            const [existing] = await db.query('SELECT * FROM users WHERE id = ?', [userId]);
            if (existing.length === 0) {
                await db.query('INSERT INTO users (id, nickname, avatar, username) VALUES (?, ?, ?, ?)', [userId, nickname, avatar, 'admin']);
            } else {
                await db.query('UPDATE users SET nickname = ?, avatar = ? WHERE id = ?', [nickname, avatar, userId]);
            }
            const [users] = await db.query('SELECT * FROM users WHERE id = ?', [userId]);
             const user = users[0];
            const userInfo = {
                nickname: user.nickname,
                avatar: user.avatar,
                userId: user.id.toString(),
                username: user.username,
                balance: 100.00,
                points: 520,
                coupons: 3
            };
            res.json({ code: 0, data: userInfo, message: '更新成功' });
            return;
        } catch (retryError) {
             console.error('Retry error:', retryError);
        }
    }
    res.status(500).json({ code: 500, message: 'Internal Server Error' });
  }
});

// --- 收藏 & 历史 API ---

// 获取收藏列表
app.get('/api/favorites', async (req, res) => {
  const userId = 1;
  try {
    const sql = `
      SELECT p.* FROM favorites f
      JOIN products p ON f.product_id = p.id
      WHERE f.user_id = ?
      ORDER BY f.created_at DESC
    `;
    const [rows] = await db.query(sql, [userId]);
    res.json({ code: 0, data: rows, message: 'success' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ code: 500, message: 'Internal Server Error' });
  }
});

// 检查是否收藏
app.get('/api/favorite/check', async (req, res) => {
  const userId = 1;
  const { productId } = req.query;
  try {
    const [rows] = await db.query('SELECT * FROM favorites WHERE user_id = ? AND product_id = ?', [userId, productId]);
    res.json({ code: 0, data: rows.length > 0, message: 'success' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ code: 500, message: 'Internal Server Error' });
  }
});

// 切换收藏状态
app.post('/api/favorite', async (req, res) => {
  const userId = 1;
  const { productId } = req.body;
  try {
    const [rows] = await db.query('SELECT * FROM favorites WHERE user_id = ? AND product_id = ?', [userId, productId]);
    if (rows.length > 0) {
      // 取消收藏
      await db.query('DELETE FROM favorites WHERE user_id = ? AND product_id = ?', [userId, productId]);
      res.json({ code: 0, data: false, message: '已取消收藏' });
    } else {
      // 添加收藏
      await db.query('INSERT INTO favorites (user_id, product_id) VALUES (?, ?)', [userId, productId]);
      res.json({ code: 0, data: true, message: '已收藏' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ code: 500, message: 'Internal Server Error' });
  }
});

// 批量删除收藏
app.delete('/api/favorites', async (req, res) => {
  const userId = 1;
  const { ids } = req.body; // productIds array
  if (!ids || !Array.isArray(ids) || ids.length === 0) {
      return res.json({ code: 0, message: 'success' });
  }
  try {
    // 构造 IN (?) 查询
    const placeholders = ids.map(() => '?').join(',');
    const sql = `DELETE FROM favorites WHERE user_id = ? AND product_id IN (${placeholders})`;
    await db.query(sql, [userId, ...ids]);
    res.json({ code: 0, message: '删除成功' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ code: 500, message: 'Internal Server Error' });
  }
});

// 获取历史记录
app.get('/api/history', async (req, res) => {
  const userId = 1;
  try {
    const sql = `
      SELECT p.* FROM history h
      JOIN products p ON h.product_id = p.id
      WHERE h.user_id = ?
      ORDER BY h.updated_at DESC
    `;
    const [rows] = await db.query(sql, [userId]);
    res.json({ code: 0, data: rows, message: 'success' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ code: 500, message: 'Internal Server Error' });
  }
});

// 添加历史记录
app.post('/api/history', async (req, res) => {
  const userId = 1;
  const { productId } = req.body;
  try {
    // 使用 ON DUPLICATE KEY UPDATE 更新时间
    const sql = `
      INSERT INTO history (user_id, product_id) VALUES (?, ?)
      ON DUPLICATE KEY UPDATE updated_at = CURRENT_TIMESTAMP
    `;
    await db.query(sql, [userId, productId]);
    res.json({ code: 0, message: 'success' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ code: 500, message: 'Internal Server Error' });
  }
});

// 批量删除历史记录
app.delete('/api/history', async (req, res) => {
  const userId = 1;
  const { ids } = req.body; // productIds array
  if (!ids || !Array.isArray(ids) || ids.length === 0) {
      return res.json({ code: 0, message: 'success' });
  }
  try {
    const placeholders = ids.map(() => '?').join(',');
    const sql = `DELETE FROM history WHERE user_id = ? AND product_id IN (${placeholders})`;
    await db.query(sql, [userId, ...ids]);
    res.json({ code: 0, message: '删除成功' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ code: 500, message: 'Internal Server Error' });
  }
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
