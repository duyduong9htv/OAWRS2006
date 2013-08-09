-- phpMyAdmin SQL Dump
-- version 3.4.7.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Feb 14, 2012 at 01:18 PM
-- Server version: 5.0.92
-- PHP Version: 5.2.9

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `nontriv1_luars`
--

-- --------------------------------------------------------

--
-- Table structure for table `tracks`
--

CREATE TABLE IF NOT EXISTS `tracks` (
  `track_id` int(11) NOT NULL auto_increment,
  `name` char(5) NOT NULL,
  `dataDir` char(9) NOT NULL,
  PRIMARY KEY  (`track_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=58 ;

--
-- Dumping data for table `tracks`
--

INSERT INTO `tracks` (`track_id`, `name`, `dataDir`) VALUES
(1, '1_1', '262-SEP19'),
(2, '2_1', '263-SEP20'),
(3, '503_1', '264-SEP21'),
(4, '552_1', '264-SEP21'),
(5, '510_1', '265-SEP22'),
(6, '510_2', '265-SEP22'),
(7, '511_1', '265-SEP22'),
(8, '511_2', '265-SEP22'),
(9, '520_1', '269-SEP26'),
(10, '521_1', '269-SEP26'),
(11, '522_1', '269-SEP26'),
(12, '522_2', '269-SEP26'),
(13, '530_1', '270-SEP27'),
(14, '530_2', '270-SEP27'),
(15, '531_1', '270-SEP27'),
(16, '532_1', '270-SEP27'),
(17, '532_2', '270-SEP27'),
(18, '532_3', '270-SEP27'),
(19, '532_4', '270-SEP27'),
(20, '532_5', '270-SEP27'),
(21, '530_3', '271-SEP28'),
(22, '531_2', '271-SEP28'),
(23, '540_1', '271-SEP28'),
(24, '540_2', '271-SEP28'),
(25, '550_1', '272-SEP29'),
(26, '551_1', '272-SEP29'),
(27, '551_2', '272-SEP29'),
(28, '551_3', '272-SEP29'),
(29, '553_1', '272-SEP29'),
(30, '560_1', '273-SEP30'),
(31, '560_2', '273-SEP30'),
(32, '564_1', '273-SEP30'),
(33, '564_2', '273-SEP30'),
(34, '564_3', '273-SEP30'),
(35, '566_1', '273-SEP30'),
(36, '570_1', '274-OCT01'),
(37, '570_2', '274-OCT01'),
(38, '571_1', '274-OCT01'),
(39, '571_2', '274-OCT01'),
(40, '570_3', '275-OCT02'),
(41, '570_4', '275-OCT02'),
(42, '571_3', '275-OCT02'),
(43, '571_4', '275-OCT02'),
(44, '571_5', '275-OCT02'),
(45, '570_5', '276-OCT03'),
(46, '570_6', '276-OCT03'),
(47, '570_7', '276-OCT03'),
(48, '571_6', '276-OCT03'),
(49, '571_7', '276-OCT03'),
(50, '580_1', '277-OCT04'),
(51, '582_1', '277-OCT04'),
(52, '582_2', '277-OCT04'),
(53, '582_3', '277-OCT04'),
(54, '582_4', '277-OCT04'),
(55, '582_5', '277-OCT04'),
(56, '590_1', '279-OCT06'),
(57, '590_2', '279-OCT06');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
