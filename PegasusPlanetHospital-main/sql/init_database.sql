-- ============================================
-- 飞马星球医院预约挂号系统数据库脚本
-- 数据库名称: pegasus_hospital
-- 创建时间: 2024
-- 字符集: UTF-8
-- ============================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS pegasus_hospital 
DEFAULT CHARACTER SET utf8mb4 
DEFAULT COLLATE utf8mb4_unicode_ci;

USE pegasus_hospital;

-- 禁用外键检查，防止删除表时报错
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================
-- 1. 科室表 (Department)
-- ============================================
DROP TABLE IF EXISTS `department`;
CREATE TABLE `department` (
    `dept_id` INT AUTO_INCREMENT PRIMARY KEY COMMENT '科室ID',
    `dept_name` VARCHAR(30) NOT NULL COMMENT '科室名称',
    `description` VARCHAR(200) COMMENT '科室描述',
    `location` VARCHAR(50) COMMENT '科室位置',
    `phone` VARCHAR(20) COMMENT '科室电话',
    `status` TINYINT DEFAULT 1 COMMENT '状态: 1-正常, 0-停用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY `uk_dept_name` (`dept_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='科室信息表';

-- ============================================
-- 2. 医生表 (Doctor)
-- ============================================
DROP TABLE IF EXISTS `doctor`;
CREATE TABLE `doctor` (
    `doctor_id` CHAR(8) PRIMARY KEY COMMENT '医生ID(8位数字)',
    `name` VARCHAR(20) NOT NULL COMMENT '医生姓名',
    `password` VARCHAR(64) NOT NULL COMMENT '登录密码(加密存储)',
    `dept_id` INT NOT NULL COMMENT '所属科室ID',
    `specialty` VARCHAR(200) COMMENT '专长描述',
    `title` VARCHAR(20) COMMENT '职称',
    `phone` VARCHAR(20) COMMENT '联系电话',
    `email` VARCHAR(50) COMMENT '电子邮箱',
    `photo` VARCHAR(200) COMMENT '照片路径',
    `status` TINYINT DEFAULT 1 COMMENT '状态: 1-在职, 0-离职',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    KEY `idx_dept_id` (`dept_id`),
    CONSTRAINT `fk_doctor_dept` FOREIGN KEY (`dept_id`) REFERENCES `department` (`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='医生信息表';

-- ============================================
-- 3. 患者表 (Patient)
-- ============================================
DROP TABLE IF EXISTS `patient`;
CREATE TABLE `patient` (
    `patient_id` CHAR(10) PRIMARY KEY COMMENT '患者ID(10位数字)',
    `name` VARCHAR(20) NOT NULL COMMENT '患者姓名',
    `password` VARCHAR(64) NOT NULL COMMENT '登录密码(加密存储)',
    `id_card` CHAR(18) NOT NULL COMMENT '身份证号(18位)',
    `phone` VARCHAR(20) NOT NULL COMMENT '手机号',
    `gender` CHAR(1) NOT NULL COMMENT '性别: M-男, F-女',
    `birthday` DATE COMMENT '出生日期',
    `address` VARCHAR(200) COMMENT '地址',
    `email` VARCHAR(50) COMMENT '电子邮箱',
    `status` TINYINT DEFAULT 1 COMMENT '状态: 1-正常, 0-已注销',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY `uk_id_card` (`id_card`),
    KEY `idx_phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='患者信息表';

-- ============================================
-- 4. 医生排班表 (Schedule)
-- ============================================
DROP TABLE IF EXISTS `schedule`;
CREATE TABLE `schedule` (
    `schedule_id` INT AUTO_INCREMENT PRIMARY KEY COMMENT '排班ID',
    `doctor_id` CHAR(8) NOT NULL COMMENT '医生ID',
    `schedule_date` DATE NOT NULL COMMENT '排班日期',
    `time_slot` VARCHAR(20) NOT NULL COMMENT '时间段(如: 08:00-08:30)',
    `max_patients` INT DEFAULT 10 COMMENT '最大预约数',
    `current_patients` INT DEFAULT 0 COMMENT '当前预约数',
    `status` TINYINT DEFAULT 1 COMMENT '状态: 1-可预约, 0-已满, -1-停诊',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    KEY `idx_doctor_date` (`doctor_id`, `schedule_date`),
    KEY `idx_schedule_date` (`schedule_date`),
    CONSTRAINT `fk_schedule_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`doctor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='医生排班表';

-- ============================================
-- 5. 预约记录表 (Appointment)
-- ============================================
DROP TABLE IF EXISTS `appointment`;
CREATE TABLE `appointment` (
    `appointment_id` CHAR(12) PRIMARY KEY COMMENT '预约号(12位数字)',
    `patient_id` CHAR(10) NOT NULL COMMENT '患者ID',
    `doctor_id` CHAR(8) NOT NULL COMMENT '医生ID',
    `schedule_id` INT NOT NULL COMMENT '排班ID',
    `appointment_date` DATE NOT NULL COMMENT '预约日期',
    `time_slot` VARCHAR(20) NOT NULL COMMENT '预约时间段',
    `status` VARCHAR(20) DEFAULT 'BOOKED' COMMENT '状态: BOOKED-已预约, CANCELLED-已取消, COMPLETED-已完成',
    `cancel_reason` VARCHAR(200) COMMENT '取消原因',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    KEY `idx_patient_id` (`patient_id`),
    KEY `idx_doctor_id` (`doctor_id`),
    KEY `idx_appointment_date` (`appointment_date`),
    KEY `idx_status` (`status`),
    CONSTRAINT `fk_appointment_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`),
    CONSTRAINT `fk_appointment_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`doctor_id`),
    CONSTRAINT `fk_appointment_schedule` FOREIGN KEY (`schedule_id`) REFERENCES `schedule` (`schedule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='预约记录表';

-- ============================================
-- 6. 管理员表 (Admin)
-- ============================================
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
    `admin_id` INT AUTO_INCREMENT PRIMARY KEY COMMENT '管理员ID',
    `username` VARCHAR(50) NOT NULL COMMENT '用户名',
    `password` VARCHAR(64) NOT NULL COMMENT '密码(加密存储)',
    `name` VARCHAR(20) COMMENT '姓名',
    `phone` VARCHAR(20) COMMENT '电话',
    `role` VARCHAR(20) DEFAULT 'ADMIN' COMMENT '角色: ADMIN-管理员, SUPER-超级管理员',
    `status` TINYINT DEFAULT 1 COMMENT '状态: 1-正常, 0-禁用',
    `last_login` DATETIME COMMENT '最后登录时间',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员表';

-- ============================================
-- 7. 系统日志表 (SystemLog)
-- ============================================
DROP TABLE IF EXISTS `system_log`;
CREATE TABLE `system_log` (
    `log_id` BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '日志ID',
    `user_type` VARCHAR(20) COMMENT '用户类型: PATIENT, DOCTOR, ADMIN',
    `user_id` VARCHAR(20) COMMENT '用户ID',
    `action` VARCHAR(50) COMMENT '操作类型',
    `content` TEXT COMMENT '操作内容',
    `ip_address` VARCHAR(50) COMMENT 'IP地址',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
    KEY `idx_user` (`user_type`, `user_id`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统日志表';

-- ============================================
-- 初始化数据
-- ============================================

-- 插入科室数据
INSERT INTO `department` (`dept_name`, `description`, `location`, `phone`) VALUES
('内科', '负责诊治各种内科疾病，包括呼吸系统、消化系统、心血管系统等疾病', '门诊楼1层', '010-12345001'),
('外科', '负责诊治需要手术治疗的各种疾病，包括普外、骨科、泌尿外科等', '门诊楼2层', '010-12345002'),
('儿科', '专门诊治婴幼儿及儿童的各种疾病', '门诊楼3层', '010-12345003'),
('妇产科', '负责妇科疾病诊治及产科服务', '门诊楼4层', '010-12345004'),
('眼科', '诊治各种眼部疾病，提供视力检查及配镜服务', '门诊楼5层', '010-12345005'),
('耳鼻喉科', '诊治耳、鼻、咽、喉部疾病', '门诊楼5层', '010-12345006'),
('皮肤科', '诊治各种皮肤病及性传播疾病', '门诊楼6层', '010-12345007'),
('口腔科', '诊治各种口腔疾病，提供牙科服务', '门诊楼6层', '010-12345008'),
('中医科', '运用中医理论诊治各种疾病', '门诊楼7层', '010-12345009'),
('神经内科', '诊治各种神经系统疾病', '门诊楼7层', '010-12345010');

-- 插入医生数据 (密码: 123456)
INSERT INTO `doctor` (`doctor_id`, `name`, `password`, `dept_id`, `specialty`, `title`) VALUES
('10000001', '张三丰', 'e10adc3949ba59abbe56e057f20f883e', 1, '擅长呼吸系统疾病、慢性支气管炎、肺炎的诊治', '主任医师'),
('10000002', '李时珍', 'e10adc3949ba59abbe56e057f20f883e', 1, '擅长消化系统疾病、胃炎、肝病的诊治', '副主任医师'),
('10000003', '华佗', 'e10adc3949ba59abbe56e057f20f883e', 2, '擅长普通外科手术、腹腔镜微创手术', '主任医师'),
('10000004', '扁鹊', 'e10adc3949ba59abbe56e057f20f883e', 2, '擅长骨科疾病、关节置换手术', '副主任医师'),
('10000005', '钱乙', 'e10adc3949ba59abbe56e057f20f883e', 3, '擅长小儿常见病、儿童发育问题', '主任医师'),
('10000006', '孙思邈', 'e10adc3949ba59abbe56e057f20f883e', 9, '擅长中医内科、中医养生保健', '主任医师'),
('10000007', '王叔和', 'e10adc3949ba59abbe56e057f20f883e', 4, '擅长妇科常见病、产前检查', '副主任医师'),
('10000008', '葛洪', 'e10adc3949ba59abbe56e057f20f883e', 7, '擅长各种皮肤病、过敏性疾病', '主治医师'),
('10000009', '皇甫谧', 'e10adc3949ba59abbe56e057f20f883e', 10, '擅长头痛、眩晕、神经衰弱', '副主任医师'),
('10000010', '叶天士', 'e10adc3949ba59abbe56e057f20f883e', 5, '擅长眼底病、白内障、青光眼', '主任医师');

-- 生成排班数据（为每个医生生成未来7天的排班）
-- 使用存储过程生成排班数据
DELIMITER //
CREATE PROCEDURE generate_schedules()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE j INT DEFAULT 0;
    DECLARE current_doctor CHAR(8);
    DECLARE sched_date DATE;
    DECLARE slot VARCHAR(20);
    
    -- 遍历所有医生
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur CURSOR FOR SELECT doctor_id FROM doctor;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- 时间段数组
    SET @slots = '08:00-08:30,08:30-09:00,09:00-09:30,09:30-10:00,10:00-10:30,10:30-11:00,14:00-14:30,14:30-15:00,15:00-15:30,15:30-16:00,16:00-16:30,16:30-17:00';
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO current_doctor;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- 为每个医生生成7天的排班
        SET i = 0;
        WHILE i < 14 DO
            SET sched_date = DATE_ADD(CURDATE(), INTERVAL i DAY);
            
            -- 只在工作日排班（周一到周五）
            IF DAYOFWEEK(sched_date) NOT IN (1, 7) THEN
                -- 上午时间段
                INSERT INTO `schedule` (`doctor_id`, `schedule_date`, `time_slot`, `max_patients`) VALUES
                (current_doctor, sched_date, '08:00-08:30', 5),
                (current_doctor, sched_date, '08:30-09:00', 5),
                (current_doctor, sched_date, '09:00-09:30', 5),
                (current_doctor, sched_date, '09:30-10:00', 5),
                (current_doctor, sched_date, '10:00-10:30', 5),
                (current_doctor, sched_date, '10:30-11:00', 5);
                
                -- 下午时间段
                INSERT INTO `schedule` (`doctor_id`, `schedule_date`, `time_slot`, `max_patients`) VALUES
                (current_doctor, sched_date, '14:00-14:30', 5),
                (current_doctor, sched_date, '14:30-15:00', 5),
                (current_doctor, sched_date, '15:00-15:30', 5),
                (current_doctor, sched_date, '15:30-16:00', 5),
                (current_doctor, sched_date, '16:00-16:30', 5),
                (current_doctor, sched_date, '16:30-17:00', 5);
            END IF;
            
            SET i = i + 1;
        END WHILE;
    END LOOP;
    
    CLOSE cur;
END //
DELIMITER ;

-- 执行存储过程生成排班
CALL generate_schedules();

-- 删除存储过程
DROP PROCEDURE IF EXISTS generate_schedules;

-- 插入管理员数据 (用户名: admin, 密码: admin123)
INSERT INTO `admin` (`username`, `password`, `name`, `phone`, `role`) VALUES
('admin', '0192023a7bbd73250516f069df18b500', '系统管理员', '010-88888888', 'SUPER');

-- 插入测试患者数据 (密码: 123456)
INSERT INTO `patient` (`patient_id`, `name`, `password`, `id_card`, `phone`, `gender`, `birthday`, `address`) VALUES
('1000000001', '测试患者', 'e10adc3949ba59abbe56e057f20f883e', '110101199001011234', '13800138000', 'M', '1990-01-01', '飞马星球第一大街1号');

-- ============================================
-- 创建视图
-- ============================================

-- 科室预约统计视图
CREATE OR REPLACE VIEW `v_dept_appointment_stats` AS
SELECT 
    d.dept_id,
    d.dept_name,
    COUNT(a.appointment_id) as total_appointments,
    SUM(CASE WHEN a.status = 'BOOKED' THEN 1 ELSE 0 END) as booked_count,
    SUM(CASE WHEN a.status = 'COMPLETED' THEN 1 ELSE 0 END) as completed_count,
    SUM(CASE WHEN a.status = 'CANCELLED' THEN 1 ELSE 0 END) as cancelled_count
FROM department d
LEFT JOIN doctor doc ON d.dept_id = doc.dept_id
LEFT JOIN appointment a ON doc.doctor_id = a.doctor_id
GROUP BY d.dept_id, d.dept_name;

-- 医生工作量统计视图
CREATE OR REPLACE VIEW `v_doctor_workload` AS
SELECT 
    doc.doctor_id,
    doc.name as doctor_name,
    d.dept_name,
    COUNT(a.appointment_id) as total_appointments,
    SUM(CASE WHEN a.status = 'COMPLETED' THEN 1 ELSE 0 END) as completed_count,
    SUM(CASE WHEN a.status = 'CANCELLED' THEN 1 ELSE 0 END) as cancelled_count
FROM doctor doc
LEFT JOIN department d ON doc.dept_id = d.dept_id
LEFT JOIN appointment a ON doc.doctor_id = a.doctor_id
GROUP BY doc.doctor_id, doc.name, d.dept_name;

-- ============================================
-- 脚本执行完成
-- ============================================
-- 恢复外键检查
SET FOREIGN_KEY_CHECKS = 1;

SELECT '数据库初始化完成!' AS message;
