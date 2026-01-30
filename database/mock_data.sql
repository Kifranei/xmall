-- 增加更多商品数据
INSERT INTO `products` (`category_id`, `name`, `price`, `sales`, `main_image`) VALUES 
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

-- 增加订单数据 (覆盖不同状态)
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

-- 退款/售后 (status=4，对应前端的 status=5 映射)
INSERT INTO `orders` (`order_no`, `user_id`, `total_amount`, `status`) VALUES 
('ORD202601300006', 1, 199.00, 4),
('ORD202601300007', 1, 79.00, 4);

INSERT INTO `order_items` (`order_id`, `product_id`, `product_name`, `product_image`, `price`, `quantity`) VALUES 
((SELECT id FROM orders WHERE order_no='ORD202601300006'), 10, 'Midea 美的 电饭煲 4L 智能预约', 'https://fastly.jsdelivr.net/npm/@vant/assets/ipad.jpeg', 199.00, 1),
((SELECT id FROM orders WHERE order_no='ORD202601300007'), 11, 'Uniqlo 优衣库 女装 纯棉T恤', 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg', 79.00, 1);

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
