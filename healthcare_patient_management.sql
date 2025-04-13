
-- Healthcare Patient Management System 

-- 1. Departments Table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

-- 2. Doctors Table
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100),
    specialization VARCHAR(100),
    department_id INT,
    contact_info VARCHAR(100),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- 3. Patients Table
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100),
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Other'),
    contact_info VARCHAR(100)
);

-- 4. Appointments Table
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    doctor_id INT,
    appointment_date DATETIME,
    reason TEXT,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- 5. Diagnoses Table
CREATE TABLE Diagnoses (
    diagnosis_id INT PRIMARY KEY AUTO_INCREMENT,
    appointment_id INT,
    diagnosis TEXT,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

-- 6. Prescriptions Table
CREATE TABLE Prescriptions (
    prescription_id INT PRIMARY KEY AUTO_INCREMENT,
    diagnosis_id INT,
    medication_name VARCHAR(100),
    dosage VARCHAR(100),
    duration VARCHAR(50),
    FOREIGN KEY (diagnosis_id) REFERENCES Diagnoses(diagnosis_id)
);

-- Sample Data

INSERT INTO Departments (name) VALUES ('Cardiology'), ('Neurology'), ('Pediatrics');

INSERT INTO Doctors (full_name, specialization, department_id, contact_info) VALUES
('Dr. Alice Smith', 'Cardiologist', 1, 'alice@hospital.com'),
('Dr. John Lee', 'Neurologist', 2, 'john@hospital.com');

INSERT INTO Patients (full_name, date_of_birth, gender, contact_info) VALUES
('Michael Scott', '1975-03-15', 'Male', 'michael@dundermifflin.com'),
('Pam Beesly', '1980-06-25', 'Female', 'pam@dundermifflin.com');

INSERT INTO Appointments (patient_id, doctor_id, appointment_date, reason) VALUES
(1, 1, '2025-04-10 09:00:00', 'Chest pain'),
(2, 2, '2025-04-11 11:30:00', 'Frequent headaches');

INSERT INTO Diagnoses (appointment_id, diagnosis) VALUES
(1, 'Mild arrhythmia'),
(2, 'Tension headache');

INSERT INTO Prescriptions (diagnosis_id, medication_name, dosage, duration) VALUES
(1, 'Beta Blocker', '50mg once daily', '30 days'),
(2, 'Ibuprofen', '400mg as needed', '10 days');

-- View for Upcoming Appointments
CREATE VIEW Upcoming_Appointments AS
SELECT * FROM Appointments
WHERE appointment_date > NOW();

-- Stored Procedure to Add New Appointment
DELIMITER //
CREATE PROCEDURE AddAppointment (
    IN pat_id INT,
    IN doc_id INT,
    IN app_date DATETIME,
    IN reason_text TEXT
)
BEGIN
    INSERT INTO Appointments (patient_id, doctor_id, appointment_date, reason)
    VALUES (pat_id, doc_id, app_date, reason_text);
END;
//
DELIMITER ;

-- Missed Appointments Log Table and Trigger
CREATE TABLE MissedAppointmentsLog (
    appointment_id INT,
    missed_date DATETIME DEFAULT NOW()
);

DELIMITER //
CREATE TRIGGER LogMissedAppointment
AFTER DELETE ON Appointments
FOR EACH ROW
BEGIN
    INSERT INTO MissedAppointmentsLog (appointment_id) VALUES (OLD.appointment_id);
END;
//
DELIMITER ;
