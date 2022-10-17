SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for virtual_aliases
-- ----------------------------
-- DROP TABLE IF EXISTS `virtual_aliases`;
CREATE TABLE IF NOT EXISTS `virtual_aliases`  (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `domain_id` int(11) NOT NULL,
  `source` varchar(100) NOT NULL,
  `destination` varchar(100) NOT NULL,
  INDEX `domain_id`(`domain_id`) USING BTREE,
  FOREIGN KEY (`domain_id`) REFERENCES `virtual_domains` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COMMENT = '邮箱别名表';

-- ----------------------------
-- Table structure for virtual_domains
-- ----------------------------
-- DROP TABLE IF EXISTS `virtual_domains`;
CREATE TABLE IF NOT EXISTS `virtual_domains`  (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(50) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COMMENT = '邮箱域名';

-- ----------------------------
-- Table structure for virtual_users
-- ----------------------------
-- DROP TABLE IF EXISTS `virtual_users`;
CREATE TABLE IF NOT EXISTS `virtual_users`  (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `domain_id` int(11) NULL DEFAULT NULL,
  `password` varchar(255) NULL DEFAULT NULL,
  `email` varchar(255) NULL DEFAULT NULL,
  `name` varchar(255) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  UNIQUE INDEX `email`(`email`) USING BTREE,
  FOREIGN KEY (`domain_id`) REFERENCES `virtual_domains` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COMMENT = '邮箱用户表';

SET FOREIGN_KEY_CHECKS = 1;
