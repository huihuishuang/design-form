-- ============================================================
-- 室内设计客户需求表 - 数据库建表脚本
-- 在 Supabase SQL Editor 中执行此脚本
-- 新增字段用 ALTER TABLE 添加即可
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 客户提交主表
CREATE TABLE IF NOT EXISTS submissions (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),

  -- 一、客户基本情况
  name TEXT NOT NULL,
  gender TEXT,                -- 先生 / 女士
  age INTEGER,
  occupation TEXT,
  renovation_address TEXT,    -- 装修地址
  house_area TEXT,            -- 房屋面积
  residents TEXT[],           -- 父母, 爱人, 儿女, 亲属, 其他
  residents_other TEXT,
  pets TEXT[],                -- 猫, 狗, 其他
  pets_other TEXT,

  -- 二、空间分配
  bedroom_count TEXT,         -- 一间 / 二间 / 三间 / 四间 / 更多
  bedroom_count_other TEXT,   -- 更多时具体数量
  non_essential_spaces TEXT[],-- 书房, 长辈房, 客房, 健身区, 储物间, 衣帽间, 储藏间, 茶室
  non_essential_spaces_other TEXT,

  -- 三、风格意向（单选）
  style_preferences TEXT,     -- 现代 / 新中式 / 极简 / 美式 / 意式 / 轻法式 / 奶油风 / 中古风 / 日式
  style_other TEXT,

  -- 四、美学系统（配色）
  color_scheme TEXT[],        -- 冷色, 暖色, 中性色, 奶油色系, 暗黑系, 色彩跳跃系
  color_scheme_other TEXT,

  -- 五、舒适家居系统
  wall_materials TEXT,        -- 乳胶漆 / 艺术涂料 / 墙纸墙布 / 微水泥（单选）
  wall_materials_other TEXT,
  floor_material TEXT,        -- 全屋地砖 / 客餐厅地砖+卧室地板 / 全屋地板
  cleaning_systems TEXT[],    -- 扫地机器人, 手持式洗地机, 挂烫机, 吸尘器, 中央吸尘, 壁挂式洗衣机
  ac_heating TEXT[],          -- 中央空调, 风管机, 壁挂机, 柜机, 地暖, 暖气片, 真火壁炉
  ventilation TEXT,           -- 全房新风 / 主要空间新风 / 不需要
  water_treatment TEXT,       -- 净水器 / 前置过滤 / 直饮机 / 中央净水 / 中央软水 / 中央纯水 / 不需要（单选）
  smart_home TEXT[],          -- 全屋WIFI, 照明控制, 安防控制, 背景音乐/家庭影院

  -- 六、各空间具体需求

  -- 玄关
  entryway_functions TEXT[],  -- 全身镜, 烘鞋器
  entryway_functions_other TEXT,
  entryway_storage TEXT[],    -- 鞋子, 包, 衣服, 小物品收纳, 购物袋, 工具, 运动设备
  entryway_privacy TEXT,      -- 介意 / 无所谓

  -- 客厅
  living_functions TEXT[],    -- 家人休息, 看电视, 听音乐, 孩童玩耍
  living_functions_other TEXT,
  living_guest_frequency TEXT,-- 偶尔 / 经常 / 基本不接待
  living_guest_count INTEGER,
  living_dining_combined BOOLEAN,
  living_guest_activities TEXT[], -- 聊天, Party, 亲友聚餐
  living_no_tv_design BOOLEAN,
  living_instruments BOOLEAN,
  living_instruments_other TEXT,

  -- 餐厅
  dining_table_type TEXT,     -- 圆桌 / 长方桌 / 岛台+餐桌
  dining_tv BOOLEAN,
  dining_sideboard TEXT[],    -- 咖啡机, 操作台面, 饮水机
  dining_sideboard_other TEXT,

  -- 厨房
  kitchen_appliances TEXT[],  -- 微波炉, 烤箱, 蒸箱, 电烤箱, 消毒柜, 垃圾处理器, 洗碗机, 集成灶, 净水器, 厨房空调
  kitchen_fridge TEXT,        -- 单开门 / 双开门
  kitchen_cook_frequency TEXT,-- 每天 / 周末 / 偶尔 / 基本不
  kitchen_open BOOLEAN,

  -- 主卧
  master_bed_size TEXT,       -- 1.5x2.0 / 1.8x2.0 / 2x2.0 / 2.2x2.0
  master_bed_style TEXT,      -- 悬浮床 / 软包床头 / 落地式 / 实木床头
  master_reading BOOLEAN,
  master_dressing_table BOOLEAN,
  master_closet TEXT,         -- 必须 / 不强求
  master_bathroom_grooming BOOLEAN,
  master_bathtub BOOLEAN,
  master_av TEXT[],           -- 投影, 背景音乐
  master_av_other TEXT,
  master_water_bar BOOLEAN,

  -- 次卧
  guest_function TEXT[],      -- 临时客房 / 老人 / 子女房 / 保姆（多选）
  guest_furniture TEXT[],     -- 电脑桌, 写字台, 书柜, 梳妆台, 双人床, 单人床, 双层床

  -- 儿童房
  children_fixed BOOLEAN,
  children_gender TEXT,       -- 男孩 / 女孩
  children_age INTEGER,
  children_growth_design BOOLEAN,
  children_hobbies TEXT,
  children_drawing_board BOOLEAN,
  children_bookcase BOOLEAN,

  -- 书房
  study_activities TEXT[],    -- 读书写作, 电竞, 会客品茶, 兼客房, 辅导作业
  study_activities_other TEXT,
  study_users TEXT,           -- 一人 / 二人 / 二人以上
  study_open BOOLEAN,

  -- 阳台
  balcony_enclosed BOOLEAN,
  balcony_uses TEXT[],        -- 晒衣, 健身, 储物, 养植花木, 兼书房
  balcony_door_removed BOOLEAN,

  -- 七、其他补充
  existing_furniture BOOLEAN,
  brought_items_desc TEXT,
  brought_items_photos TEXT[],-- Supabase Storage 图片 URL 数组
  reference_photos TEXT[],    -- Supabase Storage 图片 URL 数组
  extra_notes TEXT
);

-- 开启行级安全
ALTER TABLE submissions ENABLE ROW LEVEL SECURITY;

-- 允许任何人提交（客户填表）
CREATE POLICY "allow_insert_for_all" ON submissions
  FOR INSERT WITH CHECK (true);

-- 允许任何人查看（管理后台）
CREATE POLICY "allow_select_for_all" ON submissions
  FOR SELECT USING (true);

-- 开启实时订阅
ALTER PUBLICATION supabase_realtime ADD TABLE submissions;

-- ============================================================
-- 允许更新和删除
CREATE POLICY "allow_update_for_all" ON submissions
  FOR UPDATE USING (true);

CREATE POLICY "allow_delete_for_all" ON submissions
  FOR DELETE USING (true);

-- ============================================================
-- Storage 存储桶策略（在 Supabase SQL Editor 中执行以下语句）
-- ============================================================

-- 允许公开读取上传的文件（修复后台看不到图片的问题）
-- CREATE POLICY "allow_public_read" ON storage.objects
--   FOR SELECT USING (bucket_id = 'uploads');

-- 允许公开上传文件
-- CREATE POLICY "allow_public_insert" ON storage.objects
--   FOR INSERT WITH CHECK (bucket_id = 'uploads');

-- 允许删除自己上传的文件（用于管理后台编辑）
-- CREATE POLICY "allow_public_delete" ON storage.objects
--   FOR DELETE USING (bucket_id = 'uploads');

-- ============================================================
-- 本脚本已执行过建表的项目，只需运行以下 ALTER 语句新增字段：
-- ============================================================
-- ALTER TABLE submissions ADD COLUMN IF NOT EXISTS renovation_address TEXT;
-- ALTER TABLE submissions ADD COLUMN IF NOT EXISTS house_area TEXT;
