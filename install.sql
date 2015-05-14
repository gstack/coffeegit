-- phpMyAdmin SQL Dump
-- version 4.0.10.7
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 14, 2015 at 05:50 AM
-- Server version: 5.6.23
-- PHP Version: 5.4.23

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `ruleless_coffeegit`
--

-- --------------------------------------------------------

--
-- Table structure for table `repos`
--

CREATE TABLE IF NOT EXISTS `repos` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `repo` varchar(500) NOT NULL,
  `desc` text NOT NULL,
  `path` varchar(500) NOT NULL,
  `url` varchar(500) NOT NULL,
  `userid` int(10) NOT NULL,
  `email` varchar(500) NOT NULL,
  `last_check` double NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `repo` (`repo`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `repos`
--

INSERT INTO `repos` (`id`, `repo`, `desc`, `path`, `url`, `userid`, `email`, `last_check`) VALUES
(2, 'testing31', 'test', '/Users/gray/projects/testing31', '', 1, 'owner@thelab.sh', 1419784101283),
(3, 'storm', '', '/Users/gray/Projects/storm', 'https://github.com/gstack/storm.git', 1, 'owner@thelab.sh', 1419797555585);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `username` varchar(250) NOT NULL,
  `password` varchar(150) NOT NULL,
  `email` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `users`
--

-- All of the account passwords in here are `password`

INSERT INTO `users` (`id`, `username`, `password`, `email`) VALUES
(1, 'mofo', '5f4dcc3b5aa765d61d8327deb882cf99', 'test@test.com'),
(2, 'admin', '5f4dcc3b5aa765d61d8327deb882cf99', 'admin@password.lol');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
