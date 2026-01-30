-- 清空旧分类（可选，根据需要）
TRUNCATE TABLE categories;

-- 插入一级分类
INSERT INTO categories (id, name, parent_id, sort_order) VALUES
(1, '推荐', 0, 1),
(2, '食品', 0, 2),
(3, '百货', 0, 3),
(4, '女装', 0, 4),
(5, '鞋包', 0, 5),
(6, '电器', 0, 6),
(7, '手机', 0, 7),
(8, '男装', 0, 8),
(9, '美妆', 0, 9),
(10, '运动', 0, 10);

-- 插入二级分类（子分类）
-- 推荐
INSERT INTO categories (name, parent_id, icon) VALUES
('热销榜', 1, 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg'),
('每日特价', 1, 'https://fastly.jsdelivr.net/npm/@vant/assets/leaf.jpeg'),
('新品首发', 1, 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg');

-- 食品
INSERT INTO categories (name, parent_id, icon) VALUES
('休闲零食', 2, 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg'),
('坚果炒货', 2, 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg'),
('饮料冲调', 2, 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg'),
('方便速食', 2, 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg'),
('进口食品', 2, 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg');

-- 百货
INSERT INTO categories (name, parent_id, icon) VALUES
('纸巾湿巾', 3, 'https://fastly.jsdelivr.net/npm/@vant/assets/leaf.jpeg'),
('衣物清洁', 3, 'https://fastly.jsdelivr.net/npm/@vant/assets/leaf.jpeg'),
('家庭清洁', 3, 'https://fastly.jsdelivr.net/npm/@vant/assets/leaf.jpeg'),
('收纳整理', 3, 'https://fastly.jsdelivr.net/npm/@vant/assets/leaf.jpeg'),
('厨房餐饮', 3, 'https://fastly.jsdelivr.net/npm/@vant/assets/leaf.jpeg');

-- 女装
INSERT INTO categories (name, parent_id, icon) VALUES
('连衣裙', 4, 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg'),
('T恤', 4, 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg'),
('衬衫', 4, 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg'),
('半身裙', 4, 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg'),
('牛仔裤', 4, 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg');

-- 鞋包
INSERT INTO categories (name, parent_id, icon) VALUES
('单鞋', 5, 'https://fastly.jsdelivr.net/npm/@vant/assets/ipad.jpeg'),
('运动鞋', 5, 'https://fastly.jsdelivr.net/npm/@vant/assets/ipad.jpeg'),
('双肩包', 5, 'https://fastly.jsdelivr.net/npm/@vant/assets/ipad.jpeg'),
('斜挎包', 5, 'https://fastly.jsdelivr.net/npm/@vant/assets/ipad.jpeg');

-- 电器
INSERT INTO categories (name, parent_id, icon) VALUES
('厨房电器', 6, 'https://fastly.jsdelivr.net/npm/@vant/assets/ipad.jpeg'),
('生活电器', 6, 'https://fastly.jsdelivr.net/npm/@vant/assets/ipad.jpeg'),
('个护健康', 6, 'https://fastly.jsdelivr.net/npm/@vant/assets/ipad.jpeg');

-- 手机
INSERT INTO categories (name, parent_id, icon) VALUES
('iPhone', 7, 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg'),
('华为', 7, 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-2.jpeg'),
('小米', 7, 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg'),
('OPPO', 7, 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-2.jpeg'),
('Vivo', 7, 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg');

-- 男装
INSERT INTO categories (name, parent_id, icon) VALUES
('T恤', 8, 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg'),
('休闲裤', 8, 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg'),
('夹克', 8, 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg');

-- 美妆
INSERT INTO categories (name, parent_id, icon) VALUES
('面膜', 9, 'https://fastly.jsdelivr.net/npm/@vant/assets/leaf.jpeg'),
('洁面', 9, 'https://fastly.jsdelivr.net/npm/@vant/assets/leaf.jpeg'),
('防晒', 9, 'https://fastly.jsdelivr.net/npm/@vant/assets/leaf.jpeg'),
('口红', 9, 'https://fastly.jsdelivr.net/npm/@vant/assets/leaf.jpeg');

-- 运动
INSERT INTO categories (name, parent_id, icon) VALUES
('跑步鞋', 10, 'https://fastly.jsdelivr.net/npm/@vant/assets/ipad.jpeg'),
('运动服', 10, 'https://fastly.jsdelivr.net/npm/@vant/assets/ipad.jpeg'),
('健身器材', 10, 'https://fastly.jsdelivr.net/npm/@vant/assets/ipad.jpeg');
