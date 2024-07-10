-- Create database
CREATE DATABASE HospitalityManagementSystem;
USE HospitalityManagementSystem;

-- Create Users table
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username VARCHAR(50) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    UserType VARCHAR(20) NOT NULL -- e.g., 'Admin', 'Staff', 'Customer'
);

-- Create Hotels table
CREATE TABLE Hotels (
    HotelID INT PRIMARY KEY IDENTITY(1,1),
    HotelName VARCHAR(100) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    City VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL
);

-- Create RoomTypes table
CREATE TABLE RoomTypes (
    RoomTypeID INT PRIMARY KEY IDENTITY(1,1),
    TypeName VARCHAR(50) NOT NULL,
    Description TEXT,
    BasePrice DECIMAL(10, 2) NOT NULL
);

-- Create Rooms table
CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY IDENTITY(1,1),
    HotelID INT NOT NULL,
    RoomNumber VARCHAR(10) NOT NULL,
    RoomTypeID INT NOT NULL,
    FOREIGN KEY (HotelID) REFERENCES Hotels(HotelID),
    FOREIGN KEY (RoomTypeID) REFERENCES RoomTypes(RoomTypeID),
    UNIQUE (HotelID, RoomNumber)
);

-- Create Reservations table
CREATE TABLE Reservations (
    ReservationID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    RoomID INT NOT NULL,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    TotalPrice DECIMAL(10, 2) NOT NULL,
    Status VARCHAR(20) NOT NULL, -- e.g., 'Confirmed', 'Cancelled', 'Completed'
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID)
);

-- Create Bills table
CREATE TABLE Bills (
    BillID INT PRIMARY KEY IDENTITY(1,1),
    ReservationID INT NOT NULL,
    BillDate DATE NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    PaymentStatus VARCHAR(20) NOT NULL, -- e.g., 'Paid', 'Unpaid'
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID)
);