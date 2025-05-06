-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Creato il: Mag 06, 2025 alle 18:50
-- Versione del server: 10.4.32-MariaDB
-- Versione PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `kawaii_food`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `accounts`
--

CREATE TABLE `accounts` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `money` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `accounts`
--

INSERT INTO `accounts` (`id`, `username`, `password`, `money`) VALUES
(3, 'Arlecchino', '12345678', 73.00),
(4, 'Colombina', '12345678', 36.00);

-- --------------------------------------------------------

--
-- Struttura della tabella `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `account` int(11) NOT NULL,
  `creation` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `orders`
--

INSERT INTO `orders` (`id`, `account`, `creation`) VALUES
(131, 3, '2025-05-05'),
(144, 3, '2025-05-05'),
(153, 3, '2025-05-05'),
(155, 3, '2025-05-06'),
(157, 3, '2025-05-06'),
(158, 3, '2025-05-06'),
(159, 3, '2025-05-06'),
(160, 3, '2025-05-06'),
(161, 3, '2025-05-06'),
(163, 4, '2025-05-06');

-- --------------------------------------------------------

--
-- Struttura della tabella `orders_row`
--

CREATE TABLE `orders_row` (
  `orderr` int(11) NOT NULL,
  `product` int(11) NOT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `orders_row`
--

INSERT INTO `orders_row` (`orderr`, `product`, `quantity`) VALUES
(131, 2, 1),
(131, 3, 2),
(131, 4, 2),
(144, 4, 1),
(144, 5, 3),
(153, 2, 2),
(153, 3, 1),
(153, 4, 2),
(155, 2, 2),
(155, 4, 2),
(155, 6, 3),
(157, 7, 3),
(157, 10, 1),
(158, 2, 2),
(158, 3, 1),
(158, 4, 3),
(158, 5, 3),
(159, 3, 1),
(159, 4, 1),
(159, 7, 2),
(159, 9, 1),
(159, 10, 1),
(160, 6, 1),
(161, 1, 1),
(161, 9, 2),
(163, 4, 1),
(163, 5, 2);

-- --------------------------------------------------------

--
-- Struttura della tabella `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `file` varchar(255) NOT NULL,
  `category` int(11) NOT NULL DEFAULT 0,
  `price` float(5,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `products`
--

INSERT INTO `products` (`id`, `name`, `file`, `category`, `price`) VALUES
(1, 'Burger', 'burger.png', 0, 5.00),
(2, 'Cocktail', 'cocktail.png', 0, 3.00),
(3, 'Strawberry Jelly', 'jelly.png', 0, 2.00),
(4, 'Hot-dog', 'hot-dog.png', 0, 4.00),
(5, 'Berry Jelly', 'jelly-2.png', 0, 5.00),
(6, 'Nigiri Sushi', 'nigiri.png', 0, 10.00),
(7, 'Popsicle', 'popsicle.png', 0, 1.00),
(8, 'Fried Pumpkin', 'pumpkin.png', 0, 4.00),
(9, 'Ramen', 'ramen.png', 0, 8.00),
(10, 'Caesar Salad', 'salad.png', 0, 8.00);

-- --------------------------------------------------------

--
-- Struttura della tabella `shoppingbag`
--

CREATE TABLE `shoppingbag` (
  `id` int(11) NOT NULL,
  `account` int(11) NOT NULL,
  `creation` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `shoppingbag`
--

INSERT INTO `shoppingbag` (`id`, `account`, `creation`) VALUES
(162, 3, '2025-05-06'),
(164, 4, '2025-05-06');

-- --------------------------------------------------------

--
-- Struttura della tabella `shoppingbag_row`
--

CREATE TABLE `shoppingbag_row` (
  `shoppingbag` int(11) NOT NULL,
  `product` int(11) NOT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indici per le tabelle `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account` (`account`);

--
-- Indici per le tabelle `orders_row`
--
ALTER TABLE `orders_row`
  ADD PRIMARY KEY (`orderr`,`product`),
  ADD KEY `product` (`product`);

--
-- Indici per le tabelle `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `shoppingbag`
--
ALTER TABLE `shoppingbag`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account` (`account`);

--
-- Indici per le tabelle `shoppingbag_row`
--
ALTER TABLE `shoppingbag_row`
  ADD PRIMARY KEY (`shoppingbag`,`product`),
  ADD KEY `product` (`product`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT per la tabella `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT per la tabella `shoppingbag`
--
ALTER TABLE `shoppingbag`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=165;

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`account`) REFERENCES `accounts` (`id`);

--
-- Limiti per la tabella `orders_row`
--
ALTER TABLE `orders_row`
  ADD CONSTRAINT `orders_row_ibfk_1` FOREIGN KEY (`product`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `orders_row_ibfk_2` FOREIGN KEY (`orderr`) REFERENCES `orders` (`id`);

--
-- Limiti per la tabella `shoppingbag`
--
ALTER TABLE `shoppingbag`
  ADD CONSTRAINT `shoppingbag_ibfk_1` FOREIGN KEY (`account`) REFERENCES `accounts` (`id`);

--
-- Limiti per la tabella `shoppingbag_row`
--
ALTER TABLE `shoppingbag_row`
  ADD CONSTRAINT `shoppingbag_row_ibfk_1` FOREIGN KEY (`shoppingbag`) REFERENCES `shoppingbag` (`id`),
  ADD CONSTRAINT `shoppingbag_row_ibfk_2` FOREIGN KEY (`product`) REFERENCES `products` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
