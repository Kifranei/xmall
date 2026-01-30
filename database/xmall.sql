-- ----------------------------
-- 1. 创建并选择数据库
-- ----------------------------
CREATE DATABASE IF NOT EXISTS `xmall_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE `xmall_db`;

SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- 2. 用户表 (users)
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(64) NOT NULL COMMENT '用户名',
  `password` varchar(255) NOT NULL COMMENT '密码(加密)',
  `nickname` varchar(64) DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(255) DEFAULT 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg' COMMENT '头像',
  `balance` decimal(10,2) DEFAULT '0.00' COMMENT '余额',
  `points` int(11) DEFAULT '0' COMMENT '积分',
  `coupons` int(11) DEFAULT '0' COMMENT '优惠券数量',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

INSERT INTO `users` (`username`, `password`, `nickname`, `balance`, `points`, `coupons`) VALUES 
('trae_user', '123456', 'Trae用户', 100.00, 520, 3);

-- ----------------------------
-- 3. 商品分类表 (categories)
-- ----------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `parent_id` bigint(20) DEFAULT '0' COMMENT '父分类ID，0表示一级分类',
  `name` varchar(64) NOT NULL COMMENT '分类名称',
  `icon` varchar(255) DEFAULT NULL COMMENT '图标URL',
  `sort_order` int(11) DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品分类表';

-- ----------------------------
-- 4. 商品表 (products)
-- ----------------------------
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `category_id` bigint(20) DEFAULT NULL COMMENT '分类ID',
  `name` varchar(128) NOT NULL COMMENT '商品名称',
  `description` text COMMENT '商品简介',
  `price` decimal(10,2) NOT NULL COMMENT '销售价格',
  `original_price` decimal(10,2) DEFAULT NULL COMMENT '原价',
  `main_image` varchar(255) DEFAULT NULL COMMENT '主图',
  `images` text COMMENT '轮播图JSON数组',
  `sales` int(11) DEFAULT '0' COMMENT '销量',
  `stock` int(11) DEFAULT '999' COMMENT '库存',
  `status` tinyint(4) DEFAULT '1' COMMENT '状态 1:上架 0:下架',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品表';

-- ----------------------------
-- 5. 购物车表 (carts)
-- ----------------------------
DROP TABLE IF EXISTS `carts`;
CREATE TABLE `carts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `product_id` bigint(20) NOT NULL COMMENT '商品ID',
  `quantity` int(11) DEFAULT '1' COMMENT '数量',
  `selected` tinyint(1) DEFAULT '1' COMMENT '是否选中',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='购物车表';

-- ----------------------------
-- 6. 收货地址表 (addresses)
-- ----------------------------
DROP TABLE IF EXISTS `addresses`;
CREATE TABLE `addresses` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `name` varchar(32) NOT NULL COMMENT '收货人',
  `tel` varchar(20) NOT NULL COMMENT '联系电话',
  `province` varchar(32) NOT NULL COMMENT '省',
  `city` varchar(32) NOT NULL COMMENT '市',
  `county` varchar(32) NOT NULL COMMENT '区/县',
  `address_detail` varchar(255) NOT NULL COMMENT '详细地址',
  `is_default` tinyint(1) DEFAULT '0' COMMENT '是否默认',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='收货地址表';

INSERT INTO `addresses` (`user_id`, `name`, `tel`, `province`, `city`, `county`, `address_detail`, `is_default`) VALUES 
(1, '张三', '13800138000', '浙江省', '杭州市', '西湖区', '文三路 123 号', 1);

-- ----------------------------
-- 7. 订单表 (orders)
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `order_no` varchar(64) NOT NULL COMMENT '订单号',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `total_amount` decimal(10,2) NOT NULL COMMENT '订单总金额',
  `status` tinyint(4) DEFAULT '0' COMMENT '0:待付款 1:待发货 2:待收货 3:已完成 4:已取消',
  `address_snapshot` text COMMENT '收货地址快照',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- ----------------------------
-- 8. 订单详情表 (order_items)
-- ----------------------------
DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) NOT NULL COMMENT '订单ID',
  `product_id` bigint(20) NOT NULL COMMENT '商品ID',
  `product_name` varchar(128) NOT NULL COMMENT '商品名称快照',
  `product_image` varchar(255) DEFAULT NULL COMMENT '商品图片快照',
  `price` decimal(10,2) NOT NULL COMMENT '购买价格',
  `quantity` int(11) DEFAULT '1' COMMENT '购买数量',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单详情表';

-- ----------------------------
-- 9. 收藏表 (favorites)
-- ----------------------------
CREATE TABLE IF NOT EXISTS `favorites` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `product_id` bigint(20) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_product` (`user_id`, `product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- 10. 历史记录表 (history)
-- ----------------------------
CREATE TABLE IF NOT EXISTS `history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `product_id` bigint(20) NOT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_product` (`user_id`, `product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- 11. 初始化数据：分类 (Categories)
-- ----------------------------
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

-- ----------------------------
-- 12. 初始化数据：商品 (Products)
-- ----------------------------
-- 插入初始商品 (合并了原 init.sql 和 mock_data.sql 的内容)
INSERT INTO `products` (`category_id`, `name`, `price`, `sales`, `main_image`) VALUES 
(7, 'iPhone 15 Pro Max 256GB 远峰蓝', 8999.00, 1024, 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg'),
(7, 'Xiaomi 14 Ultra 摄影专业套装', 6999.00, 500, 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-2.jpeg'),
(2, '三只松鼠 每日坚果 30包/箱', 129.00, 50000, 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg'),
(6, 'Dyson 戴森 V12 Detect Slim 吸尘器', 4599.00, 200, 'https://fastly.jsdelivr.net/npm/@vant/assets/ipad.jpeg'),
(7, 'Samsung Galaxy S24 Ultra 钛灰 512GB', 9699.00, 300, 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg'),
(7, 'OnePlus 12 16GB+512GB 留白', 4799.00, 800, 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-2.jpeg'),
(7, 'Vivo X100 Pro 落日橙 1TB', 5999.00, 600, 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg'),
(2, '良品铺子 猪肉脯 200g/袋', 29.90, 12000, 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg'),
(2, '旺旺 仙贝 520g 大礼包', 35.00, 8000, 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg'),
(2, '卫龙 辣条大面筋 65g*10包', 19.90, 50000, 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg'),
(3, '维达 抽纸 3层120抽*24包', 59.90, 20000, 'https://fastly.jsdelivr.net/npm/@vant/assets/leaf.jpeg'),
(3, '蓝月亮 洗衣液 3kg+1kg', 49.90, 15000, 'https://fastly.jsdelivr.net/npm/@vant/assets/leaf.jpeg'),
(6, 'Philips 飞利浦 电动牙刷 HX6730', 299.00, 5000, 'https://fastly.jsdelivr.net/npm/@vant/assets/ipad.jpeg'),
(6, 'Midea 美的 电饭煲 4L 智能预约', 199.00, 8000, 'https://fastly.jsdelivr.net/npm/@vant/assets/ipad.jpeg'),
(4, 'Uniqlo 优衣库 女装 纯棉T恤', 79.00, 3000, 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg'),
(4, 'Zara 女装 连衣裙 夏季新款', 299.00, 1000, 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg'),
(8, 'Nike 耐克 男子 运动卫衣', 399.00, 2000, 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg'),
(8, 'Adidas 阿迪达斯 休闲长裤', 349.00, 1500, 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg');

-- ----------------------------
-- 13. 初始化数据：订单 (Orders)
-- ----------------------------
-- 待付款 (status=0)
INSERT INTO `orders` (`order_no`, `user_id`, `total_amount`, `status`) VALUES 
('ORD202601300001', 1, 8999.00, 0),
('ORD202601300002', 1, 158.90, 0);

INSERT INTO `order_items` (`order_id`, `product_id`, `product_name`, `product_image`, `price`, `quantity`) VALUES 
((SELECT id FROM orders WHERE order_no='ORD202601300001'), 1, 'iPhone 15 Pro Max 256GB 远峰蓝', 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg', 8999.00, 1),
((SELECT id FROM orders WHERE order_no='ORD202601300002'), 3, '三只松鼠 每日坚果 30包/箱', 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg', 129.00, 1),
((SELECT id FROM orders WHERE order_no='ORD202601300002'), 6, '良品铺子 猪肉脯 200g/袋', 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg', 29.90, 1);

-- 待发货 (status=1)
INSERT INTO `orders` (`order_no`, `user_id`, `total_amount`, `status`) VALUES 
('ORD202601300003', 1, 4599.00, 1);

INSERT INTO `order_items` (`order_id`, `product_id`, `product_name`, `product_image`, `price`, `quantity`) VALUES 
((SELECT id FROM orders WHERE order_no='ORD202601300003'), 4, 'Dyson 戴森 V12 Detect Slim 吸尘器', 'https://fastly.jsdelivr.net/npm/@vant/assets/ipad.jpeg', 4599.00, 1);

-- 待收货 (status=2)
INSERT INTO `orders` (`order_no`, `user_id`, `total_amount`, `status`) VALUES 
('ORD202601300004', 1, 6999.00, 2);

INSERT INTO `order_items` (`order_id`, `product_id`, `product_name`, `product_image`, `price`, `quantity`) VALUES 
((SELECT id FROM orders WHERE order_no='ORD202601300004'), 2, 'Xiaomi 14 Ultra 摄影专业套装', 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-2.jpeg', 6999.00, 1);

-- 已完成 (status=3)
INSERT INTO `orders` (`order_no`, `user_id`, `total_amount`, `status`) VALUES 
('ORD202601300005', 1, 299.00, 3);

INSERT INTO `order_items` (`order_id`, `product_id`, `product_name`, `product_image`, `price`, `quantity`) VALUES 
((SELECT id FROM orders WHERE order_no='ORD202601300005'), 9, 'Philips 飞利浦 电动牙刷 HX6730', 'https://fastly.jsdelivr.net/npm/@vant/assets/ipad.jpeg', 299.00, 1);

-- 退款/售后 (status=4)
INSERT INTO `orders` (`order_no`, `user_id`, `total_amount`, `status`) VALUES 
('ORD202601300006', 1, 199.00, 4),
('ORD202601300007', 1, 79.00, 4);

INSERT INTO `order_items` (`order_id`, `product_id`, `product_name`, `product_image`, `price`, `quantity`) VALUES 
((SELECT id FROM orders WHERE order_no='ORD202601300006'), 10, 'Midea 美的 电饭煲 4L 智能预约', 'https://fastly.jsdelivr.net/npm/@vant/assets/ipad.jpeg', 199.00, 1),
((SELECT id FROM orders WHERE order_no='ORD202601300007'), 11, 'Uniqlo 优衣库 女装 纯棉T恤', 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg', 79.00, 1);

-- ----------------------------
-- 14. 初始化数据：其他
-- ----------------------------
-- 增加收藏数据
INSERT INTO `favorites` (`user_id`, `product_id`) VALUES 
(1, 1),
(1, 4),
(1, 7);

-- 增加历史记录数据
INSERT INTO `history` (`user_id`, `product_id`, `updated_at`) VALUES 
(1, 2, NOW()),
(1, 3, DATE_SUB(NOW(), INTERVAL 1 HOUR)),
(1, 5, DATE_SUB(NOW(), INTERVAL 2 HOUR)),
(1, 8, DATE_SUB(NOW(), INTERVAL 1 DAY));

SET FOREIGN_KEY_CHECKS = 1;
