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

INSERT INTO `categories` (`id`, `name`, `sort_order`) VALUES (1, '推荐', 1), (2, '食品', 2), (3, '百货', 3), (4, '女装', 4), (5, '鞋包', 5), (6, '电器', 6), (7, '手机', 7), (8, '男装', 8);

INSERT INTO `categories` (`parent_id`, `name`, `icon`) VALUES 
(2, '坚果炒货', 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg'),
(2, '肉干肉脯', 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg'),
(2, '饼干蛋糕', 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg'),
(7, '华为', 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-2.jpeg'),
(7, '小米', 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-2.jpeg'),
(7, '苹果', 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-2.jpeg');

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

INSERT INTO `products` (`category_id`, `name`, `price`, `sales`, `main_image`) VALUES 
(7, 'iPhone 15 Pro Max 256GB 远峰蓝', 8999.00, 1024, 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg'),
(7, 'Xiaomi 14 Ultra 摄影专业套装', 6999.00, 500, 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-2.jpeg'),
(2, '三只松鼠 每日坚果 30包/箱', 129.00, 50000, 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg'),
(6, 'Dyson 戴森 V12 Detect Slim 吸尘器', 4599.00, 200, 'https://fastly.jsdelivr.net/npm/@vant/assets/ipad.jpeg');

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

SET FOREIGN_KEY_CHECKS = 1;
