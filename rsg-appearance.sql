CREATE TABLE IF NOT EXISTS `playerskins` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `citizenid` VARCHAR(255) NOT NULL COLLATE 'utf8mb3_general_ci',
    `skin` VARCHAR(8000) NOT NULL COLLATE 'utf8mb3_general_ci',
    `clothes` VARCHAR(8000) NOT NULL COLLATE 'utf8mb4_general_ci',
    PRIMARY KEY (`id`) USING BTREE,
    INDEX `citizenid` (`citizenid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `playeroutfit` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `citizenid` VARCHAR(50) NOT NULL COLLATE 'utf8mb3_general_ci',
    `name` VARCHAR(255) NOT NULL COLLATE 'utf8mb3_general_ci',
    `clothes` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb3_general_ci',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
