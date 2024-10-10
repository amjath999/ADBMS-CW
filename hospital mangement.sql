-- MainAdmin table (needs to be created first since it's referenced in other tables)
CREATE TABLE MainAdmins (
    AdminID NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    Age NUMBER,
    DOB DATE,
    Gender VARCHAR2(10),
    Address VARCHAR2(255),
    PhoneNo VARCHAR2(15)
);

-- WardAdmin table
CREATE TABLE WardAdmins (
    WardAdminID NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    Age NUMBER,
    DOB DATE,
    Gender VARCHAR2(10),
    Address VARCHAR2(255),
    PhoneNo VARCHAR2(15),
    AdminID NUMBER,
    CONSTRAINT fk_wardadmin_mainadmin FOREIGN KEY (AdminID) 
        REFERENCES MainAdmin(AdminID)
);

-- SurgeryAdmin table
CREATE TABLE SurgeryAdmins (
    SurgeryAdminID NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    Age NUMBER,
    DOB DATE,
    Gender VARCHAR2(10),
    Address VARCHAR2(255),
    PhoneNo VARCHAR2(15),
    AdminID NUMBER,
    CONSTRAINT fk_surgeryadmin_mainadmin FOREIGN KEY (AdminID) 
        REFERENCES MainAdmin(AdminID)
);

-- PatientAdmin table
CREATE TABLE PatientAdmins (
    PatientAdminID NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    Age NUMBER,
    DOB DATE,
    Gender VARCHAR2(10),
    Address VARCHAR2(255),
    PhoneNo VARCHAR2(15),
    AdminID NUMBER,
    CONSTRAINT fk_patientadmin_mainadmin FOREIGN KEY (AdminID) 
        REFERENCES MainAdmin(AdminID)
);

-- DoctorAdmin table
CREATE TABLE DoctorAdmins (
    DoctorAdminID NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    Age NUMBER,
    DOB DATE,
    Gender VARCHAR2(10),
    Address VARCHAR2(255),
    PhoneNo VARCHAR2(15),
    AdminID NUMBER,
    CONSTRAINT fk_doctoradmin_mainadmin FOREIGN KEY (AdminID) 
        REFERENCES MainAdmin(AdminID)
);

-- Patient table
CREATE TABLE Patient (
    PatientID NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    Age NUMBER,
    DOB DATE,
    Gender VARCHAR2(10),
    Address VARCHAR2(255),
    Contact_Info VARCHAR2(100),
    AppliID NUMBER, -- Foreign key to applications if applicable
    PatientAdminID NUMBER, -- Foreign key to PatientAdmin table
    CONSTRAINT fk_patient_patientadmins FOREIGN KEY (PatientAdminID)
        REFERENCES PatientAdmins(PatientAdminID)
);

-- Surgery table
CREATE TABLE Surgery (
    SurgeryID NUMBER PRIMARY KEY,
    Surgery_Type VARCHAR2(100),
    SurgeryAdminID NUMBER, -- Foreign key to SurgeryAdmin table
    CONSTRAINT fk_surgery_surgeryadmins FOREIGN KEY (SurgeryAdminID)
        REFERENCES SurgeryAdmins(SurgeryAdminID)
);

-- Doctor table
CREATE TABLE Doctor (
    DoctorID NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    Gender VARCHAR2(10),
    Specialization VARCHAR2(100),
    Address VARCHAR2(255),
    DoctorAdminID NUMBER, -- Foreign key to DoctorAdmin table
    CONSTRAINT fk_doctor_doctoradmins FOREIGN KEY (DoctorAdminID)
        REFERENCES DoctorAdmins(DoctorAdminID)
);

-- Appointment table
CREATE TABLE Appointment (
    AppointmentID NUMBER PRIMARY KEY,
    AppointmentDate DATE,
    AppointmentTime VARCHAR2(10),
    DoctorID NUMBER, -- Foreign key to Doctor table
    CONSTRAINT fk_appointment_doctor FOREIGN KEY (DoctorID)
        REFERENCES Doctor(DoctorID)
);


-- Ward table
CREATE TABLE Ward (
    WardID NUMBER PRIMARY KEY,
    No_of_Patients NUMBER,
    No_of_Beds NUMBER,
    WardAdminID NUMBER, -- Foreign key to WardAdmin table
    CONSTRAINT fk_ward_wardadmins FOREIGN KEY (WardAdminID)
        REFERENCES WardAdmins(WardAdminID)
);


CREATE TABLE Room (
    RoomID NUMBER PRIMARY KEY,
    Type VARCHAR2(50),
    Status VARCHAR2(50),
    Capacity NUMBER,
    WardID NUMBER, -- Foreign key to Ward table
    WardAdminID NUMBER, -- Foreign key to WardAdmin table
    CONSTRAINT fk_room_ward FOREIGN KEY (WardID)
        REFERENCES Ward(WardID),
    CONSTRAINT fk_room_wardadmins FOREIGN KEY (WardAdminID)
        REFERENCES WardAdmins(WardAdminID)
);

CREATE TABLE Payment (
    PaymentID NUMBER PRIMARY KEY,
    InvoiceNo VARCHAR2(50),
    paymentTime VARCHAR2(10),
    paymentDate DATE,
    Status VARCHAR2(50),
    PatientID NUMBER, -- Foreign key to Patient table
    DoctorID NUMBER, -- Foreign key to Doctor table
    CONSTRAINT fk_payment_patient FOREIGN KEY (PatientID)
        REFERENCES Patient(PatientID),
    CONSTRAINT fk_payment_doctor FOREIGN KEY (DoctorID)
        REFERENCES Doctor(DoctorID)
);
CREATE OR REPLACE PROCEDURE add_mainadmin (
    p_adminID IN NUMBER,
    p_name IN VARCHAR2,
    p_age IN NUMBER,
    p_dob IN DATE,
    p_gender IN VARCHAR2,
    p_address IN VARCHAR2,
    p_phoneNo IN VARCHAR2
) AS
BEGIN
    INSERT INTO MainAdmins (AdminID, Name, Age, DOB, Gender, Address, PhoneNo)
    VALUES (p_adminID, p_name, p_age, p_dob, p_gender, p_address, p_phoneNo);
    COMMIT;
END;
/

 DELETE FROM MainAdmins;
BEGIN
    add_mainadmin(1, 'Alice Smith', 35, TO_DATE('1989-06-15', 'YYYY-MM-DD'), 'Female', '123 Main St', '1234567890');
END;
/

BEGIN
    add_mainadmin(2, 'Bob Johnson', 40, TO_DATE('1983-04-20', 'YYYY-MM-DD'), 'Male', '456 Oak St', '0987654321');
END;
/

BEGIN
    add_mainadmin(3, 'Charlie Brown', 29, TO_DATE('1994-11-02', 'YYYY-MM-DD'), 'Male', '789 Pine St', '1112233445');
END;
/

BEGIN
    add_mainadmin(4, 'David Wilson', 50, TO_DATE('1973-03-05', 'YYYY-MM-DD'), 'Male', '321 Maple St', '2223344556');
END;
/

BEGIN
    add_mainadmin(5, 'Eve Davis', 30, TO_DATE('1992-06-20', 'YYYY-MM-DD'), 'Female', '654 Cedar St', '3334455667');
END;
/


CREATE OR REPLACE PROCEDURE update_mainadmin (
    p_adminID IN NUMBER,
    p_name IN VARCHAR2,
    p_age IN NUMBER,
    p_dob IN DATE,
    p_gender IN VARCHAR2,
    p_address IN VARCHAR2,
    p_phoneNo IN VARCHAR2
) AS
BEGIN
    UPDATE MainAdmins
    SET Name = p_name,
        Age = p_age,
        DOB = p_dob,
        Gender = p_gender,
        Address = p_address,
        PhoneNo = p_phoneNo
    WHERE AdminID = p_adminID;
    COMMIT;
END;
/

BEGIN
    update_mainadmin(1, 'Alice Johnson', 36, TO_DATE('1989-06-15', 'YYYY-MM-DD'), 'Female', '456 Main St', '0987654321');
END;
/



CREATE OR REPLACE PROCEDURE get_mainadmin (
    p_adminID IN NUMBER,
    v_name OUT VARCHAR2,
    v_age OUT NUMBER,
    v_dob OUT DATE,
    v_gender OUT VARCHAR2,
    v_address OUT VARCHAR2,
    v_phoneNo OUT VARCHAR2
) AS
BEGIN
    SELECT Name, Age, DOB, Gender, Address, PhoneNo
    INTO v_name, v_age, v_dob, v_gender, v_address, v_phoneNo
    FROM MainAdmins
    WHERE AdminID = p_adminID;
END;
/


DECLARE
    v_name VARCHAR2(100);
    v_age NUMBER;
    v_dob DATE;
    v_gender VARCHAR2(10);
    v_address VARCHAR2(255);
    v_phoneNo VARCHAR2(15);
BEGIN
    get_mainadmin(1, v_name, v_age, v_dob, v_gender, v_address, v_phoneNo);
    DBMS_OUTPUT.PUT_LINE('Main Admin: ' || v_name || ', Age: ' || v_age);
END;
/

CREATE OR REPLACE PROCEDURE delete_mainadmin (
    p_adminID IN NUMBER
) AS
BEGIN
    DELETE FROM MainAdmins WHERE AdminID = p_adminID;
    COMMIT;
END;
/
BEGIN
    delete_mainadmin(5);
END;
/
CREATE OR REPLACE PROCEDURE add_wardadmin (
    p_wardAdminID IN NUMBER,
    p_name IN VARCHAR2,
    p_age IN NUMBER,
    p_dob IN DATE,
    p_gender IN VARCHAR2,
    p_address IN VARCHAR2,
    p_phoneNo IN VARCHAR2,
    p_adminID IN NUMBER
) AS
BEGIN
    INSERT INTO WardAdmins (WardAdminID, Name, Age, DOB, Gender, Address, PhoneNo, AdminID)
    VALUES (p_wardAdminID, p_name, p_age, p_dob, p_gender, p_address, p_phoneNo, p_adminID);
    COMMIT;
END;
/

BEGIN
    add_wardadmin(1, 'Ward Admin A', 34, TO_DATE('1989-07-15', 'YYYY-MM-DD'), 'Female', '125 Main St', '1234567890', 1);
END;
/

BEGIN
    add_wardadmin(2, 'Ward Admin B', 38, TO_DATE('1985-06-20', 'YYYY-MM-DD'), 'Male', '128 Oak St', '0987654321', 1);
END;
/

BEGIN
    add_wardadmin(3, 'Ward Admin C', 42, TO_DATE('1981-08-25', 'YYYY-MM-DD'), 'Female', '126 Pine St', '1112233445', 1);
END;
/

BEGIN
    add_wardadmin(4, 'Ward Admin D', 50, TO_DATE('1973-02-11', 'YYYY-MM-DD'), 'Male', '121 Maple St', '2223344556', 1);
END;
/

BEGIN
    add_wardadmin(5, 'Ward Admin E', 29, TO_DATE('1994-05-30', 'YYYY-MM-DD'), 'Female', '124 Cedar St', '3334455667', 1);
END;
/
CREATE OR REPLACE PROCEDURE update_wardadmin (
    p_wardAdminID IN NUMBER,
    p_name IN VARCHAR2,
    p_age IN NUMBER,
    p_dob IN DATE,
    p_gender IN VARCHAR2,
    p_address IN VARCHAR2,
    p_phoneNo IN VARCHAR2,
    p_adminID IN NUMBER
) AS
BEGIN
    UPDATE WardAdmins
    SET Name = p_name,
        Age = p_age,
        DOB = p_dob,
        Gender = p_gender,
        Address = p_address,
        PhoneNo = p_phoneNo,
        AdminID = p_adminID
    WHERE WardAdminID = p_wardAdminID;
    COMMIT;
END;
/


BEGIN
    update_wardadmin(1, 'Ward Admin AA', 35, TO_DATE('1989-07-15', 'YYYY-MM-DD'), 'Female', '125 Updated Main St', '9876543210', 1);
END;
/


CREATE OR REPLACE PROCEDURE get_wardadmin (
    p_wardAdminID IN NUMBER,
    v_name OUT VARCHAR2,
    v_age OUT NUMBER,
    v_dob OUT DATE,
    v_gender OUT VARCHAR2,
    v_address OUT VARCHAR2,
    v_phoneNo OUT VARCHAR2,
    v_adminID OUT NUMBER
) AS
BEGIN
    SELECT Name, Age, DOB, Gender, Address, PhoneNo, AdminID
    INTO v_name, v_age, v_dob, v_gender, v_address, v_phoneNo, v_adminID
    FROM WardAdmins
    WHERE WardAdminID = p_wardAdminID;
END;
/


DECLARE
    v_name VARCHAR2(100);
    v_age NUMBER;
    v_dob DATE;
    v_gender VARCHAR2(10);
    v_address VARCHAR2(255);
    v_phoneNo VARCHAR2(15);
    v_adminID NUMBER;
BEGIN
    get_wardadmin(1, v_name, v_age, v_dob, v_gender, v_address, v_phoneNo, v_adminID);
    DBMS_OUTPUT.PUT_LINE('Ward Admin: ' || v_name || ', Age: ' || v_age);
END;
/


CREATE OR REPLACE PROCEDURE delete_wardadmin (
    p_wardAdminID IN NUMBER
) AS
BEGIN
    DELETE FROM WardAdmins WHERE WardAdminID = p_wardAdminID;
    COMMIT;
END;
/

BEGIN
    delete_wardadmin(5);
END;
/
CREATE OR REPLACE PROCEDURE add_surgeryadmin (
    p_surgeryAdminID IN NUMBER,
    p_name IN VARCHAR2,
    p_age IN NUMBER,
    p_dob IN DATE,
    p_gender IN VARCHAR2,
    p_address IN VARCHAR2,
    p_phoneNo IN VARCHAR2,
    p_adminID IN NUMBER
) AS
BEGIN
    INSERT INTO SurgeryAdmins (SurgeryAdminID, Name, Age, DOB, Gender, Address, PhoneNo, AdminID)
    VALUES (p_surgeryAdminID, p_name, p_age, p_dob, p_gender, p_address, p_phoneNo, p_adminID);
    COMMIT;
END;
/

BEGIN
    add_surgeryadmin(1, 'Surgery Admin A', 39, TO_DATE('1984-09-15', 'YYYY-MM-DD'), 'Female', '135 Main St', '1234567890', 1);
END;
/

BEGIN
    add_surgeryadmin(2, 'Surgery Admin B', 44, TO_DATE('1979-12-20', 'YYYY-MM-DD'), 'Male', '138 Oak St', '0987654321', 1);
END;
/

BEGIN
    add_surgeryadmin(3, 'Surgery Admin C', 29, TO_DATE('1994-07-25', 'YYYY-MM-DD'), 'Female', '136 Pine St', '1112233445', 1);
END;
/

BEGIN
    add_surgeryadmin(4, 'Surgery Admin D', 54, TO_DATE('1969-02-11', 'YYYY-MM-DD'), 'Male', '131 Maple St', '2223344556', 1);
END;
/

BEGIN
    add_surgeryadmin(5, 'Surgery Admin E', 32, TO_DATE('1991-05-30', 'YYYY-MM-DD'), 'Female', '134 Cedar St', '3334455667', 1);
END;
/

CREATE OR REPLACE PROCEDURE update_surgeryadmin (
    p_surgeryAdminID IN NUMBER,
    p_name IN VARCHAR2,
    p_age IN NUMBER,
    p_dob IN DATE,
    p_gender IN VARCHAR2,
    p_address IN VARCHAR2,
    p_phoneNo IN VARCHAR2,
    p_adminID IN NUMBER
) AS
BEGIN
    UPDATE SurgeryAdmins
    SET Name = p_name,
        Age = p_age,
        DOB = p_dob,
        Gender = p_gender,
        Address = p_address,
        PhoneNo = p_phoneNo,
        AdminID = p_adminID
    WHERE SurgeryAdminID = p_surgeryAdminID;
    COMMIT;
END;
/


BEGIN
    update_surgeryadmin(1, 'Surgery Admin AA', 40, TO_DATE('1984-09-15', 'YYYY-MM-DD'), 'Female', '135 Updated Main St', '9876543210', 1);
END;
/


CREATE OR REPLACE PROCEDURE get_surgeryadmin (
    p_surgeryAdminID IN NUMBER,
    v_name OUT VARCHAR2,
    v_age OUT NUMBER,
    v_dob OUT DATE,
    v_gender OUT VARCHAR2,
    v_address OUT VARCHAR2,
    v_phoneNo OUT VARCHAR2,
    v_adminID OUT NUMBER
) AS
BEGIN
    SELECT Name, Age, DOB, Gender, Address, PhoneNo, AdminID
    INTO v_name, v_age, v_dob, v_gender, v_address, v_phoneNo, v_adminID
    FROM SurgeryAdmins
    WHERE SurgeryAdminID = p_surgeryAdminID;
END;
/


DECLARE
    v_name VARCHAR2(100);
    v_age NUMBER;
    v_dob DATE;
    v_gender VARCHAR2(10);
    v_address VARCHAR2(255);
    v_phoneNo VARCHAR2(15);
    v_adminID NUMBER;
BEGIN
    get_surgeryadmin(1, v_name, v_age, v_dob, v_gender, v_address, v_phoneNo, v_adminID);
    DBMS_OUTPUT.PUT_LINE('Surgery Admin: ' || v_name || ', Age: ' || v_age);
END;
/


CREATE OR REPLACE PROCEDURE delete_surgeryadmin (
    p_surgeryAdminID IN NUMBER
) AS
BEGIN
    DELETE FROM SurgeryAdmins WHERE SurgeryAdminID = p_surgeryAdminID;
    COMMIT;
END;
/

BEGIN
    delete_surgeryadmin(5);
END;
/

CREATE OR REPLACE PROCEDURE add_patientadmin (
    p_patientAdminID IN NUMBER,
    p_name IN VARCHAR2,
    p_age IN NUMBER,
    p_dob IN DATE,
    p_gender IN VARCHAR2,
    p_address IN VARCHAR2,
    p_phoneNo IN VARCHAR2,
    p_adminID IN NUMBER
) AS
BEGIN
    INSERT INTO PatientAdmins (PatientAdminID, Name, Age, DOB, Gender, Address, PhoneNo, AdminID)
    VALUES (p_patientAdminID, p_name, p_age, p_dob, p_gender, p_address, p_phoneNo, p_adminID);
    COMMIT;
END;
/

BEGIN
    add_patientadmin(1, 'Patient Admin A', 28, TO_DATE('1995-10-05', 'YYYY-MM-DD'), 'Female', '145 Main St', '1234567890', 1);
END;
/

BEGIN
    add_patientadmin(2, 'Patient Admin B', 35, TO_DATE('1988-01-25', 'YYYY-MM-DD'), 'Male', '148 Oak St', '0987654321', 1);
END;
/

BEGIN
    add_patientadmin(3, 'Patient Admin C', 45, TO_DATE('1978-04-15', 'YYYY-MM-DD'), 'Female', '146 Pine St', '1112233445', 1);
END;
/

BEGIN
    add_patientadmin(4, 'Patient Admin D', 32, TO_DATE('1991-07-30', 'YYYY-MM-DD'), 'Male', '141 Maple St', '2223344556', 1);
END;
/

BEGIN
    add_patientadmin(5, 'Patient Admin E', 40, TO_DATE('1983-08-20', 'YYYY-MM-DD'), 'Female', '144 Cedar St', '3334455667', 1);
END;
/

CREATE OR REPLACE PROCEDURE update_patientadmin (
    p_patientAdminID IN NUMBER,
    p_name IN VARCHAR2,
    p_age IN NUMBER,
    p_dob IN DATE,
    p_gender IN VARCHAR2,
    p_address IN VARCHAR2,
    p_phoneNo IN VARCHAR2,
    p_adminID IN NUMBER
) AS
BEGIN
    UPDATE PatientAdmins
    SET Name = p_name,
        Age = p_age,
        DOB = p_dob,
        Gender = p_gender,
        Address = p_address,
        PhoneNo = p_phoneNo,
        AdminID = p_adminID
    WHERE PatientAdminID = p_patientAdminID;
    COMMIT;
END;
/

BEGIN
    update_patientadmin(1, 'Patient Admin AA', 29, TO_DATE('1995-10-05', 'YYYY-MM-DD'), 'Female', '145 Updated Main St', '9876543210', 1);
END;
/


CREATE OR REPLACE PROCEDURE get_patientadmin (
    p_patientAdminID IN NUMBER,
    v_name OUT VARCHAR2,
    v_age OUT NUMBER,
    v_dob OUT DATE,
    v_gender OUT VARCHAR2,
    v_address OUT VARCHAR2,
    v_phoneNo OUT VARCHAR2,
    v_adminID OUT NUMBER
) AS
BEGIN
    SELECT Name, Age, DOB, Gender, Address, PhoneNo, AdminID
    INTO v_name, v_age, v_dob, v_gender, v_address, v_phoneNo, v_adminID
    FROM PatientAdmins
    WHERE PatientAdminID = p_patientAdminID;
END;
/


DECLARE
    v_name VARCHAR2(100);
    v_age NUMBER;
    v_dob DATE;
    v_gender VARCHAR2(10);
    v_address VARCHAR2(255);
    v_phoneNo VARCHAR2(15);
    v_adminID NUMBER;
BEGIN
    get_patientadmin(1, v_name, v_age, v_dob, v_gender, v_address, v_phoneNo, v_adminID);
    DBMS_OUTPUT.PUT_LINE('Patient Admin: ' || v_name || ', Age: ' || v_age);
END;
/

CREATE OR REPLACE PROCEDURE delete_patientadmin (
    p_patientAdminID IN NUMBER
) AS
BEGIN
    DELETE FROM PatientAdmins WHERE PatientAdminID = p_patientAdminID;
    COMMIT;
END;
/

BEGIN
    delete_patientadmin(5);
END;
/
CREATE OR REPLACE PROCEDURE add_doctoradmin (
    p_doctorAdminID IN NUMBER,
    p_name IN VARCHAR2,
    p_age IN NUMBER,
    p_dob IN DATE,
    p_gender IN VARCHAR2,
    p_address IN VARCHAR2,
    p_phoneNo IN VARCHAR2,
    p_adminID IN NUMBER
) AS
BEGIN
    INSERT INTO DoctorAdmins (DoctorAdminID, Name, Age, DOB, Gender, Address, PhoneNo, AdminID)
    VALUES (p_doctorAdminID, p_name, p_age, p_dob, p_gender, p_address, p_phoneNo, p_adminID);
    COMMIT;
END;
/

BEGIN
    add_doctoradmin(1, 'Doctor Admin A', 45, TO_DATE('1978-11-18', 'YYYY-MM-DD'), 'Female', '155 Main St', '1234567890', 1);
END;
/

BEGIN
    add_doctoradmin(2, 'Doctor Admin B', 38, TO_DATE('1985-01-12', 'YYYY-MM-DD'), 'Male', '158 Oak St', '0987654321', 1);
END;
/

BEGIN
    add_doctoradmin(3, 'Doctor Admin C', 30, TO_DATE('1993-06-20', 'YYYY-MM-DD'), 'Female', '156 Pine St', '1112233445', 1);
END;
/

BEGIN
    add_doctoradmin(4, 'Doctor Admin D', 52, TO_DATE('1971-03-14', 'YYYY-MM-DD'), 'Male', '151 Maple St', '2223344556', 1);
END;
/

BEGIN
    add_doctoradmin(5, 'Doctor Admin E', 29, TO_DATE('1994-05-28', 'YYYY-MM-DD'), 'Female', '154 Cedar St', '3334455667', 1);
END;
/


CREATE OR REPLACE PROCEDURE update_doctoradmin (
    p_doctorAdminID IN NUMBER,
    p_name IN VARCHAR2,
    p_age IN NUMBER,
    p_dob IN DATE,
    p_gender IN VARCHAR2,
    p_address IN VARCHAR2,
    p_phoneNo IN VARCHAR2,
    p_adminID IN NUMBER
) AS
BEGIN
    UPDATE DoctorAdmins
    SET Name = p_name,
        Age = p_age,
        DOB = p_dob,
        Gender = p_gender,
        Address = p_address,
        PhoneNo = p_phoneNo,
        AdminID = p_adminID
    WHERE DoctorAdminID = p_doctorAdminID;
    COMMIT;
END;
/


BEGIN
    update_doctoradmin(1, 'Doctor Admin AA', 46, TO_DATE('1978-11-18', 'YYYY-MM-DD'), 'Female', '155 Updated Main St', '9876543210', 1);
END;
/
CREATE OR REPLACE PROCEDURE get_doctoradmin (
    p_doctorAdminID IN NUMBER,
    v_name OUT VARCHAR2,
    v_age OUT NUMBER,
    v_dob OUT DATE,
    v_gender OUT VARCHAR2,
    v_address OUT VARCHAR2,
    v_phoneNo OUT VARCHAR2,
    v_adminID OUT NUMBER
) AS
BEGIN
    SELECT Name, Age, DOB, Gender, Address, PhoneNo, AdminID
    INTO v_name, v_age, v_dob, v_gender, v_address, v_phoneNo, v_adminID
    FROM DoctorAdmins
    WHERE DoctorAdminID = p_doctorAdminID;
END;
/
DECLARE
    v_name VARCHAR2(100);
    v_age NUMBER;
    v_dob DATE;
    v_gender VARCHAR2(10);
    v_address VARCHAR2(255);
    v_phoneNo VARCHAR2(15);
    v_adminID NUMBER;
BEGIN
    get_doctoradmin(1, v_name, v_age, v_dob, v_gender, v_address, v_phoneNo, v_adminID);
    DBMS_OUTPUT.PUT_LINE('Doctor Admin: ' || v_name || ', Age: ' || v_age);
END;
/


CREATE OR REPLACE PROCEDURE add_patient (
    p_patientID IN NUMBER,
    p_name IN VARCHAR2,
    p_age IN NUMBER,
    p_dob IN DATE,
    p_gender IN VARCHAR2,
    p_address IN VARCHAR2,
    p_phoneNo IN VARCHAR2,
    p_adminID IN NUMBER
) AS
BEGIN
    INSERT INTO Patient (PatientID, Name, Age, DOB, Gender, Address, PhoneNo, AdminID)
    VALUES (p_patientID, p_name, p_age, p_dob, p_gender, p_address, p_phoneNo, p_adminID);
    COMMIT;
END;
/
CREATE OR REPLACE PROCEDURE add_doctor (
    p_doctorID IN NUMBER,
    p_name IN VARCHAR2,
    p_specialization IN VARCHAR2,
    p_age IN NUMBER,
    p_dob IN DATE,
    p_gender IN VARCHAR2,
    p_address IN VARCHAR2,
    p_phoneNo IN VARCHAR2
) AS
BEGIN
    INSERT INTO Doctors (DoctorID, Name, Specialization, Age, DOB, Gender, Address, PhoneNo)
    VALUES (p_doctorID, p_name, p_specialization, p_age, p_dob, p_gender, p_address, p_phoneNo);
    COMMIT;
END;
/



-- Procedure to add a new Patient
CREATE OR REPLACE PROCEDURE add_patient (
    p_PatientID IN NUMBER,
    p_Name IN VARCHAR2,
    p_Age IN NUMBER,
    p_DOB IN DATE,
    p_Gender IN VARCHAR2,
    p_Address IN VARCHAR2,
    p_Contact_Info IN VARCHAR2,
    p_AppliID IN NUMBER,
    p_PatientAdminID IN NUMBER
) AS
BEGIN
    INSERT INTO Patient (PatientID, Name, Age, DOB, Gender, Address, Contact_Info, AppliID, PatientAdminID)
    VALUES (p_PatientID, p_Name, p_Age, p_DOB, p_Gender, p_Address, p_Contact_Info, p_AppliID, p_PatientAdminID);
    COMMIT;
END;
/

-- Procedure to update Patient
CREATE OR REPLACE PROCEDURE update_patient (
    p_PatientID IN NUMBER,
    p_Name IN VARCHAR2,
    p_Age IN NUMBER,
    p_DOB IN DATE,
    p_Gender IN VARCHAR2,
    p_Address IN VARCHAR2,
    p_Contact_Info IN VARCHAR2,
    p_AppliID IN NUMBER,
    p_PatientAdminID IN NUMBER
) AS
BEGIN
    UPDATE Patient
    SET Name = p_Name, Age = p_Age, DOB = p_DOB, Gender = p_Gender,
        Address = p_Address, Contact_Info = p_Contact_Info, AppliID = p_AppliID, PatientAdminID = p_PatientAdminID
    WHERE PatientID = p_PatientID;
    COMMIT;
END;
/

-- Procedure to get Patient details
CREATE OR REPLACE PROCEDURE get_patient (
    p_PatientID IN NUMBER
) AS
    v_Name VARCHAR2(100);
    v_Age NUMBER;
    v_DOB DATE;
    v_Gender VARCHAR2(10);
    v_Address VARCHAR2(255);
    v_Contact_Info VARCHAR2(15);
    v_AppliID NUMBER;
    v_PatientAdminID NUMBER;
BEGIN
    SELECT Name, Age, DOB, Gender, Address, Contact_Info, AppliID, PatientAdminID
    INTO v_Name, v_Age, v_DOB, v_Gender, v_Address, v_Contact_Info, v_AppliID, v_PatientAdminID
    FROM Patient
    WHERE PatientID = p_PatientID;

    DBMS_OUTPUT.PUT_LINE('Patient: ' || v_Name || ', Age: ' || v_Age);
END;
/

-- Procedure to delete Patient
CREATE OR REPLACE PROCEDURE delete_patient (
    p_PatientID IN NUMBER
) AS
BEGIN
    DELETE FROM Patient WHERE PatientID = p_PatientID;
    COMMIT;
END;
/



-- Procedure to add a new Doctor
CREATE OR REPLACE PROCEDURE add_doctor (
    p_DoctorID IN NUMBER,
    p_Name IN VARCHAR2,
    p_Gender IN VARCHAR2,
    p_Specialization IN VARCHAR2,
    p_Address IN VARCHAR2,
    p_DoctorAdminID IN NUMBER
) AS
BEGIN
    INSERT INTO Doctor (DoctorID, Name, Gender, Specialization, Address, DoctorAdminID)
    VALUES (p_DoctorID, p_Name, p_Gender, p_Specialization, p_Address, p_DoctorAdminID);
    COMMIT;
END;
/

-- Procedure to update Doctor
CREATE OR REPLACE PROCEDURE update_doctor (
    p_DoctorID IN NUMBER,
    p_Name IN VARCHAR2,
    p_Gender IN VARCHAR2,
    p_Specialization IN VARCHAR2,
    p_Address IN VARCHAR2,
    p_DoctorAdminID IN NUMBER
) AS
BEGIN
    UPDATE Doctor
    SET Name = p_Name, Gender = p_Gender, Specialization = p_Specialization,
        Address = p_Address, DoctorAdminID = p_DoctorAdminID
    WHERE DoctorID = p_DoctorID;
    COMMIT;
END;
/

-- Procedure to get Doctor details
CREATE OR REPLACE PROCEDURE get_doctor (
    p_DoctorID IN NUMBER
) AS
    v_Name VARCHAR2(100);
    v_Gender VARCHAR2(10);
    v_Specialization VARCHAR2(100);
    v_Address VARCHAR2(255);
    v_DoctorAdminID NUMBER;
BEGIN
    SELECT Name, Gender, Specialization, Address, DoctorAdminID
    INTO v_Name, v_Gender, v_Specialization, v_Address, v_DoctorAdminID
    FROM Doctor
    WHERE DoctorID = p_DoctorID;

    DBMS_OUTPUT.PUT_LINE('Doctor: ' || v_Name || ', Specialization: ' || v_Specialization);
END;
/

-- Procedure to delete Doctor
CREATE OR REPLACE PROCEDURE delete_doctor (
    p_DoctorID IN NUMBER
) AS
BEGIN
    DELETE FROM Doctor WHERE DoctorID = p_DoctorID;
    COMMIT;
END;
/


-- Procedure to add a new Payment
CREATE OR REPLACE PROCEDURE add_payment (
    p_PaymentID IN NUMBER,
    p_InvoiceNo IN VARCHAR2,
    p_PaymentTime IN VARCHAR2,
    p_PaymentDate IN DATE,
    p_Status IN VARCHAR2,
    p_PatientID IN NUMBER,
    p_DoctorID IN NUMBER
) AS
BEGIN
    INSERT INTO Payment (PaymentID, InvoiceNo, PaymentTime, PaymentDate, Status, PatientID, DoctorID)
    VALUES (p_PaymentID, p_InvoiceNo, p_PaymentTime, p_PaymentDate, p_Status, p_PatientID, p_DoctorID);
    COMMIT;
END;
/

-- Procedure to update Payment
CREATE OR REPLACE PROCEDURE update_payment (
    p_PaymentID IN NUMBER,
    p_InvoiceNo IN VARCHAR2,
    p_PaymentTime IN VARCHAR2,
    p_PaymentDate IN DATE,
    p_Status IN VARCHAR2,
    p_PatientID IN NUMBER,
    p_DoctorID IN NUMBER
) AS
BEGIN
    UPDATE Payment
    SET InvoiceNo = p_InvoiceNo, PaymentTime = p_PaymentTime, PaymentDate = p_PaymentDate,
        Status = p_Status, PatientID = p_PatientID, DoctorID = p_DoctorID
    WHERE PaymentID = p_PaymentID;
    COMMIT;
END;
/

-- Procedure to get Payment details
CREATE OR REPLACE PROCEDURE get_payment (
    p_PaymentID IN NUMBER
) AS
    v_InvoiceNo VARCHAR2(100);
    v_PaymentTime VARCHAR2(20);
    v_PaymentDate DATE;
    v_Status VARCHAR2(20);
    v_PatientID NUMBER;
    v_DoctorID NUMBER;
BEGIN
    SELECT InvoiceNo, PaymentTime, PaymentDate, Status, PatientID, DoctorID
    INTO v_InvoiceNo, v_PaymentTime, v_PaymentDate, v_Status, v_PatientID, v_DoctorID
    FROM Payment
    WHERE PaymentID = p_PaymentID;

    DBMS_OUTPUT.PUT_LINE('Payment: ' || v_InvoiceNo || ', Status: ' || v_Status);
END;
/

-- Procedure to delete Payment
CREATE OR REPLACE PROCEDURE delete_payment (
    p_PaymentID IN NUMBER
) AS
BEGIN
    DELETE FROM Payment WHERE PaymentID = p_PaymentID;
    COMMIT;
END;
/


-- Procedure to add a new Room
CREATE OR REPLACE PROCEDURE add_room (
    p_RoomID IN NUMBER,
    p_Type IN VARCHAR2,
    p_Status IN VARCHAR2,
    p_Capacity IN NUMBER,
    p_WardID IN NUMBER,
    p_WardAdminID IN NUMBER
) AS
BEGIN
    INSERT INTO Room (RoomID, Type, Status, Capacity, WardID, WardAdminID)
    VALUES (p_RoomID, p_Type, p_Status, p_Capacity, p_WardID, p_WardAdminID);
    COMMIT;
END;
/

-- Procedure to update Room
CREATE OR REPLACE PROCEDURE update_room (
    p_RoomID IN NUMBER,
    p_Type IN VARCHAR2,
    p_Status IN VARCHAR2,
    p_Capacity IN NUMBER,
    p_WardID IN NUMBER,
    p_WardAdminID IN NUMBER
) AS
BEGIN
    UPDATE Room
    SET Type = p_Type, Status = p_Status, Capacity = p_Capacity,
        WardID = p_WardID, WardAdminID = p_WardAdminID
    WHERE RoomID = p_RoomID;
    COMMIT;
END;
/

-- Procedure to get Room details
CREATE OR REPLACE PROCEDURE get_room (
    p_RoomID IN NUMBER
) AS
    v_Type VARCHAR2(100);
    v_Status VARCHAR2(20);
    v_Capacity NUMBER;
    v_WardID NUMBER;
    v_WardAdminID NUMBER;
BEGIN
    SELECT Type, Status, Capacity, WardID, WardAdminID
    INTO v_Type, v_Status, v_Capacity, v_WardID, v_WardAdminID
    FROM Room
    WHERE RoomID = p_RoomID;

    DBMS_OUTPUT.PUT_LINE('Room Type: ' || v_Type || ', Status: ' || v_Status);
END;
/

-- Procedure to delete Room
CREATE OR REPLACE PROCEDURE delete_room (
    p_RoomID IN NUMBER
) AS
BEGIN
    DELETE FROM Room WHERE RoomID = p_RoomID;
    COMMIT;
END;
/


-- Procedure to add a new Appointment
CREATE OR REPLACE PROCEDURE add_appointment (
    p_AppointmentID IN NUMBER,
    p_AppointmentDate IN DATE,
    p_AppointmentTime IN VARCHAR2,
    p_DoctorID IN NUMBER
) AS
BEGIN
    INSERT INTO Appointment (AppointmentID, AppointmentDate, AppointmentTime, DoctorID)
    VALUES (p_AppointmentID, p_AppointmentDate, p_AppointmentTime, p_DoctorID);
    COMMIT;
END;
/

-- Procedure to update Appointment
CREATE OR REPLACE PROCEDURE update_appointment (
    p_AppointmentID IN NUMBER,
    p_AppointmentDate IN DATE,
    p_AppointmentTime IN VARCHAR2,
    p_DoctorID IN NUMBER
) AS
BEGIN
    UPDATE Appointment
    SET AppointmentDate = p_AppointmentDate, AppointmentTime = p_AppointmentTime, DoctorID = p_DoctorID
    WHERE AppointmentID = p_AppointmentID;
    COMMIT;
END;
/

-- Procedure to get Appointment details
CREATE OR REPLACE PROCEDURE get_appointment (
    p_AppointmentID IN NUMBER
) AS
    v_AppointmentDate DATE;
    v_AppointmentTime VARCHAR2(20);
    v_DoctorID NUMBER;
BEGIN
    SELECT AppointmentDate, AppointmentTime, DoctorID
    INTO v_AppointmentDate, v_AppointmentTime, v_DoctorID
    FROM Appointment
    WHERE AppointmentID = p_AppointmentID;

    DBMS_OUTPUT.PUT_LINE('Appointment Date: ' || TO_CHAR(v_AppointmentDate, 'YYYY-MM-DD') || ', Time: ' || v_AppointmentTime);
END;
/

-- Procedure to delete Appointment
CREATE OR REPLACE PROCEDURE delete_appointment (
    p_AppointmentID IN NUMBER
) AS
BEGIN
    DELETE FROM Appointment WHERE AppointmentID = p_AppointmentID;
    COMMIT;
END;
/
-- Procedure to add a new Surgery
CREATE OR REPLACE PROCEDURE add_surgery (
    p_SurgeryID IN NUMBER,
    p_Surgery_Type IN VARCHAR2,
    p_SurgeryAdminID IN NUMBER
) AS
BEGIN
    INSERT INTO Surgery (SurgeryID, Surgery_Type, SurgeryAdminID)
    VALUES (p_SurgeryID, p_Surgery_Type, p_SurgeryAdminID);
    COMMIT;
END;
/

-- Procedure to update Surgery
CREATE OR REPLACE PROCEDURE update_surgery (
    p_SurgeryID IN NUMBER,
    p_Surgery_Type IN VARCHAR2,
    p_SurgeryAdminID IN NUMBER
) AS
BEGIN
    UPDATE Surgery
    SET Surgery_Type = p_Surgery_Type, SurgeryAdminID = p_SurgeryAdminID
    WHERE SurgeryID = p_SurgeryID;
    COMMIT;
END;
/

-- Procedure to get Surgery details
CREATE OR REPLACE PROCEDURE get_surgery (
    p_SurgeryID IN NUMBER
) AS
    v_Surgery_Type VARCHAR2(100);
    v_SurgeryAdminID NUMBER;
BEGIN
    SELECT Surgery_Type, SurgeryAdminID
    INTO v_Surgery_Type, v_SurgeryAdminID
    FROM Surgery
    WHERE SurgeryID = p_SurgeryID;

    DBMS_OUTPUT.PUT_LINE('Surgery Type: ' || v_Surgery_Type);
END;
/

-- Procedure to delete Surgery
CREATE OR REPLACE PROCEDURE delete_surgery (
    p_SurgeryID IN NUMBER
) AS
BEGIN
    DELETE FROM Surgery WHERE SurgeryID = p_SurgeryID;
    COMMIT;
END;
/


-- Procedure to add a new Ward
CREATE OR REPLACE PROCEDURE add_ward (
    p_WardID IN NUMBER,
    p_No_of_Patients IN NUMBER,
    p_No_of_Beds IN NUMBER,
    p_WardAdminID IN NUMBER
) AS
BEGIN
    INSERT INTO Ward (WardID, No_of_Patients, No_of_Beds, WardAdminID)
    VALUES (p_WardID, p_No_of_Patients, p_No_of_Beds, p_WardAdminID);
    COMMIT;
END;
/

-- Procedure to update Ward
CREATE OR REPLACE PROCEDURE update_ward (
    p_WardID IN NUMBER,
    p_No_of_Patients IN NUMBER,
    p_No_of_Beds IN NUMBER,
    p_WardAdminID IN NUMBER
) AS
BEGIN
    UPDATE Ward
    SET No_of_Patients = p_No_of_Patients, No_of_Beds = p_No_of_Beds, WardAdminID = p_WardAdminID
    WHERE WardID = p_WardID;
    COMMIT;
END;
/

-- Procedure to get Ward details
CREATE OR REPLACE PROCEDURE get_ward (
    p_WardID IN NUMBER
) AS
    v_No_of_Patients NUMBER;
    v_No_of_Beds NUMBER;
    v_WardAdminID NUMBER;
BEGIN
    SELECT No_of_Patients, No_of_Beds, WardAdminID
    INTO v_No_of_Patients, v_No_of_Beds, v_WardAdminID
    FROM Ward
    WHERE WardID = p_WardID;

    DBMS_OUTPUT.PUT_LINE('Ward No of Patients: ' || v_No_of_Patients || ', No of Beds: ' || v_No_of_Beds);
END;
/

-- Procedure to delete Ward
CREATE OR REPLACE PROCEDURE delete_ward (
    p_WardID IN NUMBER
) AS
BEGIN
    DELETE FROM Ward WHERE WardID = p_WardID;
    COMMIT;
END;
/

BEGIN
    add_patient(1, 'Alice', 28, TO_DATE('1996-01-15', 'YYYY-MM-DD'), 'Female', '123 Street A', '0771234567', NULL, 1);
    add_patient(2, 'Bob', 34, TO_DATE('1990-02-20', 'YYYY-MM-DD'), 'Male', '456 Street B', '0782345678', NULL, 1);
    add_patient(3, 'Charlie', 45, TO_DATE('1978-03-30', 'YYYY-MM-DD'), 'Male', '789 Street C', '0793456789', NULL, 1);
    add_patient(4, 'Diana', 50, TO_DATE('1973-04-25', 'YYYY-MM-DD'), 'Female', '159 Street D', '0714567890', NULL, 1);
    add_patient(5, 'Ethan', 40, TO_DATE('1983-05-15', 'YYYY-MM-DD'), 'Male', '753 Street E', '0725678901', NULL, 1);
END;
/

BEGIN
    update_patient(1, 'Alice Johnson', 29, TO_DATE('1996-01-15', 'YYYY-MM-DD'), 'Female', '123 Street A', '0771234567', NULL, 1);
END;
/


BEGIN
    get_patient(1);
END;
/

BEGIN
    delete_patient(5);
END;
/


-- Insert Doctors
BEGIN
    add_doctor(1, 'Dr. Smith', 'Male', 'Cardiology', '123 Doctor Ave', 1);
    add_doctor(2, 'Dr. Jane', 'Female', 'Neurology', '456 Doctor Blvd', 1);
    add_doctor(3, 'Dr. Green', 'Male', 'Pediatrics', '789 Doctor Rd', 1);
    add_doctor(4, 'Dr. Brown', 'Male', 'Orthopedics', '159 Doctor St', 1);
    add_doctor(5, 'Dr. White', 'Female', 'Dermatology', '753 Doctor Pl', 1);
END;
/

-- Update a Doctor
BEGIN
    update_doctor(1, 'Dr. Smithson', 'Male', 'Cardiology', '123 Doctor Ave', 1);
END;
/

-- Get a Doctor
BEGIN
    get_doctor(1);
END;
/

-- Delete a Doctor
BEGIN
    delete_doctor(5);
END;
/
-- Insert Surgeries
BEGIN
    add_surgery(1, 'Appendectomy', 1);
    add_surgery(2, 'Cataract Surgery', 1);
    add_surgery(3, 'Knee Replacement', 2);
    add_surgery(4, 'Heart Bypass', 2);
    add_surgery(5, 'Hip Replacement', 3);
END;
/

-- Update a Surgery
BEGIN
    update_surgery(1, 'Appendectomy Modified', 1);
END;
/

-- Get a Surgery
BEGIN
    get_surgery(1);
END;
/

-- Delete a Surgery
BEGIN
    delete_surgery(1);
END;
/


-- Insert Wards
BEGIN
    add_ward(1, 10, 15, 1);
    add_ward(2, 20, 25, 1);
    add_ward(3, 15, 20, 1);
    add_ward(4, 8, 10, 1);
    add_ward(5, 12, 15, 1);
END;
/

-- Update a Ward
BEGIN
    update_ward(1, 11, 16, 1);
END;
/

-- Get a Ward
BEGIN
    get_ward(1);
END;
/

-- Delete a Ward
BEGIN
    delete_ward(1);
END;
/CREATE OR REPLACE PROCEDURE update_payment (
    p_paymentId IN NUMBER,
    p_invoiceNo IN VARCHAR2,
    p_paymentTime IN VARCHAR2,
    p_paymentDate IN DATE,
    p_status IN VARCHAR2,
    p_patientId IN NUMBER,
    p_doctorId IN NUMBER
) AS
BEGIN
    UPDATE Payment
    SET InvoiceNo = p_invoiceNo,
        paymentTime = p_paymentTime,
        paymentDate = p_paymentDate,
        Status = p_status,
        PatientID = p_patientId,
        DoctorID = p_doctorId
    WHERE PaymentID = p_paymentId;
    COMMIT;
END;
/

BEGIN
    update_payment(1, 'INV-001', '01:00 PM', TO_DATE('2024-10-09', 'YYYY-MM-DD'), 'Paid', 1, 1);
END;
/
CREATE OR REPLACE PROCEDURE update_appointment (
    p_appointmentId IN NUMBER,
    p_appointmentDate IN DATE,
    p_appointmentTime IN VARCHAR2,
    p_doctorId IN NUMBER
) AS
BEGIN
    UPDATE Appointment
    SET AppointmentDate = p_appointmentDate,
        AppointmentTime = p_appointmentTime,
        DoctorID = p_doctorId
    WHERE AppointmentID = p_appointmentId;
    COMMIT;
END;
/


BEGIN
    update_appointment(1, TO_DATE('2024-10-15', 'YYYY-MM-DD'), '11:00 AM', 1);
END;
/


CREATE OR REPLACE PROCEDURE update_room (
    p_roomId IN NUMBER,
    p_type IN VARCHAR2,
    p_status IN VARCHAR2,
    p_capacity IN NUMBER,
    p_wardId IN NUMBER,
    p_wardAdminId IN NUMBER
) AS
BEGIN
    UPDATE Room
    SET Type = p_type,
        Status = p_status,
        Capacity = p_capacity,
        WardID = p_wardId,
        WardAdminID = p_wardAdminId
    WHERE RoomID = p_roomId;
    COMMIT;
END;
/


BEGIN
    update_room(1, 'Single', 'Occupied', 1, 1, 1);
END;
/

BEGIN
    get_payment(1); -- Assuming you have a procedure to fetch the payment details
END;
/

BEGIN
    get_appointment(1); -- Assuming you have a procedure to fetch appointment details
END;
/

select*from payment;

-- Insert Rooms
BEGIN
    add_room(1, 'Single', 'Available', 1, 1, 1);
    add_room(2, 'Double', 'Available', 2, 1, 1);
    add_room(3, 'ICU', 'Occupied', 1, 1, 1);
    add_room(4, 'General', 'Available', 3, 1, 1);
    add_room(5, 'Maternity', 'Available', 2, 1, 1);
END;
/

-- Update a Room
BEGIN
    update_room(1, 'Single', 'Occupied', 1, 1, 1);
END;
/

-- Get a Room
BEGIN
    get_room(1);
END;
/

-- Delete a Room
BEGIN
    delete_room(1);
END;
/

select*from ward;
CREATE OR REPLACE PROCEDURE get_all_admins IS
    CURSOR admin_cursor IS
        SELECT 'Ward Admin' AS AdminType, WardAdminID AS AdminID, Name
        FROM WardAdmins
        UNION
        SELECT 'Surgery Admin' AS AdminType, SurgeryAdminID AS AdminID, Name
        FROM SurgeryAdmins
        UNION
        SELECT 'Patient Admin' AS AdminType, PatientAdminID AS AdminID, Name
        FROM PatientAdmins
        UNION
        SELECT 'Doctor Admin' AS AdminType, DoctorAdminID AS AdminID, Name
        FROM DoctorAdmins;
BEGIN
    FOR admin_record IN admin_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('Admin Type: ' || admin_record.AdminType || 
                             ', Admin ID: ' || admin_record.AdminID || 
                             ', Name: ' || admin_record.Name);
    END LOOP;
END;
/
CREATE OR REPLACE PROCEDURE get_ward_admin_wards(
    p_wardAdminID IN NUMBER
) IS
    CURSOR ward_cursor IS
        SELECT WardID, No_of_Patients, No_of_Beds
        FROM Ward
        WHERE WardAdminID = p_wardAdminID;
BEGIN
    FOR ward_record IN ward_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('Ward ID: ' || ward_record.WardID || 
                             ', No. of Patients: ' || ward_record.No_of_Patients || 
                             ', No. of Beds: ' || ward_record.No_of_Beds);
    END LOOP;
END;
/
CREATE OR REPLACE PROCEDURE get_surgery_admin_surgeries(
    p_surgeryAdminID IN NUMBER
) IS
    CURSOR surgery_cursor IS
        SELECT SurgeryID, Surgery_Type
        FROM Surgery
        WHERE SurgeryAdminID = p_surgeryAdminID;
BEGIN
    FOR surgery_record IN surgery_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('Surgery ID: ' || surgery_record.SurgeryID || 
                             ', Surgery Type: ' || surgery_record.Surgery_Type);
    END LOOP;
END;
/
CREATE OR REPLACE PROCEDURE get_patient_admin_patients(
    p_patientAdminID IN NUMBER
) IS
    CURSOR patient_cursor IS
        SELECT PatientID, Name, Age, Gender
        FROM Patient
        WHERE PatientAdminID = p_patientAdminID;
BEGIN
    FOR patient_record IN patient_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('Patient ID: ' || patient_record.PatientID || 
                             ', Name: ' || patient_record.Name || 
                             ', Age: ' || patient_record.Age || 
                             ', Gender: ' || patient_record.Gender);
    END LOOP;
END;
/
CREATE OR REPLACE PROCEDURE get_doctor_admin_doctors(
    p_doctorAdminID IN NUMBER
) IS
    CURSOR doctor_cursor IS
        SELECT DoctorID, Name, Specialization
        FROM Doctor
        WHERE DoctorAdminID = p_doctorAdminID;
BEGIN
    FOR doctor_record IN doctor_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('Doctor ID: ' || doctor_record.DoctorID || 
                             ', Name: ' || doctor_record.Name || 
                             ', Specialization: ' || doctor_record.Specialization);
    END LOOP;
END;
/
BEGIN
    get_ward_admin_wards(1);  -- Retrieves wards managed by WardAdmin with ID = 1
END;
/
BEGIN
    get_surgery_admin_surgeries(2);  -- Retrieves surgeries managed by SurgeryAdmin with ID = 2
END;
/


CREATE OR REPLACE PROCEDURE get_patient_admin_patients(
    p_patientAdminID IN NUMBER
) IS
    patient_cursor SYS_REFCURSOR;
    v_patientID Patient.PatientID%TYPE;
    v_name Patient.Name%TYPE;
    v_age Patient.Age%TYPE;
    v_dob Patient.DOB%TYPE;
BEGIN
    OPEN patient_cursor FOR
        SELECT PatientID, Name, Age, DOB
        FROM Patient
        WHERE PatientAdminID = p_patientAdminID;
    
    LOOP
        FETCH patient_cursor INTO v_patientID, v_name, v_age, v_dob;
        EXIT WHEN patient_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Patient ID: ' || v_patientID || 
                             ', Name: ' || v_name || 
                             ', Age: ' || v_age || 
                             ', DOB: ' || v_dob);
    END LOOP;

    CLOSE patient_cursor;
END;
/


CREATE OR REPLACE PROCEDURE get_doctor_admin_doctors(
    p_doctorAdminID IN NUMBER
) IS
    doctor_cursor SYS_REFCURSOR;
    v_doctorID Doctor.DoctorID%TYPE;
    v_name Doctor.Name%TYPE;
    v_specialization Doctor.Specialization%TYPE;
BEGIN
    OPEN doctor_cursor FOR
        SELECT DoctorID, Name, Specialization
        FROM Doctor
        WHERE DoctorAdminID = p_doctorAdminID;
    
    LOOP
        FETCH doctor_cursor INTO v_doctorID, v_name, v_specialization;
        EXIT WHEN doctor_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Doctor ID: ' || v_doctorID || 
                             ', Name: ' || v_name || 
                             ', Specialization: ' || v_specialization);
    END LOOP;

    CLOSE doctor_cursor;
END;
/

CREATE OR REPLACE PROCEDURE get_patient_payments(
    p_patientID IN NUMBER
) IS
    payment_cursor SYS_REFCURSOR;
    v_paymentID Payment.PaymentID%TYPE;
    v_invoiceNo Payment.InvoiceNo%TYPE;
    v_status Payment.Status%TYPE;
BEGIN
    OPEN payment_cursor FOR
        SELECT PaymentID, InvoiceNo, Status
        FROM Payment
        WHERE PatientID = p_patientID;
    
    LOOP
        FETCH payment_cursor INTO v_paymentID, v_invoiceNo, v_status;
        EXIT WHEN payment_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Payment ID: ' || v_paymentID || 
                             ', Invoice No: ' || v_invoiceNo || 
                             ', Status: ' || v_status);
    END LOOP;

    CLOSE payment_cursor;
END;
/



CREATE OR REPLACE PROCEDURE get_ward_admin_rooms(
    p_wardAdminID IN NUMBER
) IS
    room_cursor SYS_REFCURSOR;
    v_roomID Room.RoomID%TYPE;
    v_type Room.Type%TYPE;
    v_status Room.Status%TYPE;
BEGIN
    OPEN room_cursor FOR
        SELECT RoomID, Type, Status
        FROM Room
        WHERE WardAdminID = p_wardAdminID;
    
    LOOP
        FETCH room_cursor INTO v_roomID, v_type, v_status;
        EXIT WHEN room_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Room ID: ' || v_roomID || 
                             ', Type: ' || v_type || 
                             ', Status: ' || v_status);
    END LOOP;

    CLOSE room_cursor;
END;
/


CREATE OR REPLACE PROCEDURE get_doctor_appointments(
    p_doctorID IN NUMBER
) IS
    appointment_cursor SYS_REFCURSOR;
    v_appointmentID Appointment.AppointmentID%TYPE;
    v_appointmentDate Appointment.AppointmentDate%TYPE;
    v_appointmentTime Appointment.AppointmentTime%TYPE;
BEGIN
    OPEN appointment_cursor FOR
        SELECT AppointmentID, AppointmentDate, AppointmentTime
        FROM Appointment
        WHERE DoctorID = p_doctorID;
    
    LOOP
        FETCH appointment_cursor INTO v_appointmentID, v_appointmentDate, v_appointmentTime;
        EXIT WHEN appointment_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Appointment ID: ' || v_appointmentID || 
                             ', Appointment Date: ' || v_appointmentDate || 
                             ', Appointment Time: ' || v_appointmentTime);
    END LOOP;

    CLOSE appointment_cursor;
END;
/

CREATE OR REPLACE PROCEDURE get_surgery_admin_surgeries(
    p_surgeryAdminID IN NUMBER
) IS
    surgery_cursor SYS_REFCURSOR;
    v_surgeryID Surgery.SurgeryID%TYPE;
    v_surgeryType Surgery.Surgery_Type%TYPE;
BEGIN
    OPEN surgery_cursor FOR
        SELECT SurgeryID, Surgery_Type
        FROM Surgery
        WHERE SurgeryAdminID = p_surgeryAdminID;
    
    LOOP
        FETCH surgery_cursor INTO v_surgeryID, v_surgeryType;
        EXIT WHEN surgery_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Surgery ID: ' || v_surgeryID || 
                             ', Surgery Type: ' || v_surgeryType);
    END LOOP;

    CLOSE surgery_cursor;
END;
/

 CREATE OR REPLACE PROCEDURE get_ward_admin_wards(
    p_wardAdminID IN NUMBER
) IS
    ward_cursor SYS_REFCURSOR;
    v_wardID Ward.WardID%TYPE;
    v_noOfPatients Ward.No_Of_Patients%TYPE;
    v_noOfBeds Ward.No_Of_Beds%TYPE;
BEGIN
    OPEN ward_cursor FOR
        SELECT WardID, No_Of_Patients, No_Of_Beds
        FROM Ward
        WHERE WardAdminID = p_wardAdminID;
    
    LOOP
        FETCH ward_cursor INTO v_wardID, v_noOfPatients, v_noOfBeds;
        EXIT WHEN ward_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Ward ID: ' || v_wardID || 
                             ', No of Patients: ' || v_noOfPatients || 
                             ', No of Beds: ' || v_noOfBeds);
    END LOOP;

    CLOSE ward_cursor;
END;
/
Patient Table Trigger
sql
Copy code
CREATE OR REPLACE TRIGGER trg_patient_before_insert
BEFORE INSERT ON Patient
FOR EACH ROW
BEGIN
    -- Example: Ensure PatientID is positive
    IF :NEW.PatientID <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'PatientID must be positive');
    END IF;
END;
/
2. Doctor Table Trigger
sql
Copy code
CREATE OR REPLACE TRIGGER trg_doctor_before_insert
BEFORE INSERT ON Doctor
FOR EACH ROW
BEGIN
    -- Example: Ensure DoctorID is positive
    IF :NEW.DoctorID <= 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'DoctorID must be positive');
    END IF;
END;
/
3. Payment Table Trigger
sql
Copy code
CREATE OR REPLACE TRIGGER trg_payment_before_insert
BEFORE INSERT ON Payment
FOR EACH ROW
BEGIN
    -- Example: Ensure PaymentID is positive
    IF :NEW.PaymentID <= 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'PaymentID must be positive');
    END IF;
END;
/
4. Room Table Trigger
sql
Copy code
CREATE OR REPLACE TRIGGER trg_room_before_insert
BEFORE INSERT ON Room
FOR EACH ROW
BEGIN
    -- Example: Ensure RoomID is positive
    IF :NEW.RoomID <= 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'RoomID must be positive');
    END IF;
END;
/
5. Appointment Table Trigger
sql
Copy code
CREATE OR REPLACE TRIGGER trg_appointment_before_insert
BEFORE INSERT ON Appointment
FOR EACH ROW
BEGIN
    -- Example: Ensure AppointmentID is positive
    IF :NEW.AppointmentID <= 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'AppointmentID must be positive');
    END IF;
END;
/
6. Surgery Table Trigger
sql
Copy code
CREATE OR REPLACE TRIGGER trg_surgery_before_insert
BEFORE INSERT ON Surgery
FOR EACH ROW
BEGIN
    -- Example: Ensure SurgeryID is positive
    IF :NEW.SurgeryID <= 0 THEN
        RAISE_APPLICATION_ERROR(-20006, 'SurgeryID must be positive');
    END IF;
END;
/
7. Ward Table Trigger
sql
Copy code
CREATE OR REPLACE TRIGGER trg_ward_before_insert
BEFORE INSERT ON Ward
FOR EACH ROW
BEGIN
    -- Example: Ensure WardID is positive
    IF :NEW.WardID <= 0 THEN
        RAISE_APPLICATION_ERROR(-20007, 'WardID must be positive');
    END IF;
END;
/



Main Admin Table Trigger
sql
Copy code
CREATE OR REPLACE TRIGGER trg_main_admin_before_insert
BEFORE INSERT ON MainAdmin
FOR EACH ROW
BEGIN
    -- Example: Ensure AdminID is positive
    IF :NEW.AdminID <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'AdminID must be positive');
    END IF;
END;
/
2. Surgery Admin Table Trigger
sql
Copy code
CREATE OR REPLACE TRIGGER trg_surgery_admin_before_insert
BEFORE INSERT ON SurgeryAdmin
FOR EACH ROW
BEGIN
    -- Example: Ensure AdminID is positive
    IF :NEW.AdminID <= 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'AdminID must be positive');
    END IF;
END;
/
3. Ward Admin Table Trigger
sql
Copy code
CREATE OR REPLACE TRIGGER trg_ward_admin_before_insert
BEFORE INSERT ON WardAdmin
FOR EACH ROW
BEGIN
    -- Example: Ensure AdminID is positive
    IF :NEW.AdminID <= 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'AdminID must be positive');
    END IF;
END;
/
4. Patient Admin Table Trigger
sql
Copy code
CREATE OR REPLACE TRIGGER trg_patient_admin_before_insert
BEFORE INSERT ON PatientAdmin
FOR EACH ROW
BEGIN
    -- Example: Ensure AdminID is positive
    IF :NEW.AdminID <= 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'AdminID must be positive');
    END IF;
END;
/
5. Doctor Admin Table Trigger
sql
Copy code
CREATE OR REPLACE TRIGGER trg_doctor_admin_before_insert
BEFORE INSERT ON DoctorAdmin
FOR EACH ROW
BEGIN
    -- Example: Ensure AdminID is positive
    IF :NEW.AdminID <= 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'AdminID must be positive');
    END IF;
END;
/CREATE OR REPLACE PROCEDURE generate_patient_report IS
    CURSOR patient_cursor IS
        SELECT PatientID, Name, Age, DOB, Gender, Address, Contact_Info, AppLIID, PatientAdminID
        FROM Patient;

    -- Variable to hold the formatted report output
    v_report_line VARCHAR2(400);
BEGIN
    -- Print report header
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('                  PATIENT REPORT                   ');
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('PatientID | Name          | Age | DOB        | Gender | Address         | Contact Info | AppLIID | PatientAdminID');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------------------');

    -- Loop through the patient records
    FOR patient_record IN patient_cursor LOOP
        v_report_line := patient_record.PatientID || ' | ' ||
                         patient_record.Name || ' | ' ||
                         patient_record.Age || ' | ' ||
                         TO_CHAR(patient_record.DOB, 'YYYY-MM-DD') || ' | ' ||
                         patient_record.Gender || ' | ' ||
                         patient_record.Address || ' | ' ||
                         patient_record.Contact_Info || ' | ' ||
                         NVL(patient_record.AppLIID, 'N/A') || ' | ' ||
                         patient_record.PatientAdminID;

        -- Print the formatted line
        DBMS_OUTPUT.PUT_LINE(v_report_line);
    END LOOP;

    -- Print footer
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------');
END;
/

create or replace NONEDITIONABLE PROCEDURE list_wards AS
    CURSOR c_ward IS
        SELECT WardID, No_of_Patients, No_of_Beds, WardAdminID FROM Ward;

    v_ward c_ward%ROWTYPE;
BEGIN
    OPEN c_ward;
    LOOP
        FETCH c_ward INTO v_ward;
        EXIT WHEN c_ward%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Ward ID: ' || v_ward.WardID || 
                             ', No. of Patients: ' || v_ward.No_of_Patients || 
                             ', No. of Beds: ' || v_ward.No_of_Beds || 
                             ', Ward Admin ID: ' || v_ward.WardAdminID);
    END LOOP;
    CLOSE c_ward;
END list_wards;


create or replace NONEDITIONABLE PROCEDURE report_appointments AS
    CURSOR c_appointments IS
        SELECT AppointmentID, AppointmentDate, AppointmentTime, DoctorID
        FROM Appointment;

    v_appointment c_appointments%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Appointments Report');
    DBMS_OUTPUT.PUT_LINE('-----------------------------------');
    OPEN c_appointments;
    LOOP
        FETCH c_appointments INTO v_appointment;
        EXIT WHEN c_appointments%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Appointment ID: ' || v_appointment.AppointmentID || 
                             ', Date: ' || v_appointment.AppointmentDate || 
                             ', Time: ' || v_appointment.AppointmentTime || 
                             ', Doctor ID: ' || v_appointment.DoctorID);
    END LOOP;
    CLOSE c_appointments;
END report_appointments;



create or replace NONEDITIONABLE PROCEDURE report_doctors AS
    CURSOR c_doctors IS
        SELECT DoctorID, Name, Gender, Specialization, Address
        FROM Doctor;

    v_doctor c_doctors%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Doctors Report');
    DBMS_OUTPUT.PUT_LINE('-----------------------------------');
    OPEN c_doctors;
    LOOP
        FETCH c_doctors INTO v_doctor;
        EXIT WHEN c_doctors%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Doctor ID: ' || v_doctor.DoctorID || 
                             ', Name: ' || v_doctor.Name || 
                             ', Gender: ' || v_doctor.Gender || 
                             ', Specialization: ' || v_doctor.Specialization || 
                             ', Address: ' || v_doctor.Address);
    END LOOP;
    CLOSE c_doctors;
END report_doctors;


create or replace NONEDITIONABLE PROCEDURE report_payments AS
    CURSOR c_payments IS
        SELECT PaymentID, InvoiceNo, paymentTime, paymentDate, Status, PatientID, DoctorID
        FROM Payment;

    v_payment c_payments%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Payments Report');
    DBMS_OUTPUT.PUT_LINE('-----------------------------------');
    OPEN c_payments;
    LOOP
        FETCH c_payments INTO v_payment;
        EXIT WHEN c_payments%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Payment ID: ' || v_payment.PaymentID || 
                             ', Invoice No: ' || v_payment.InvoiceNo || 
                             ', Time: ' || v_payment.paymentTime || 
                             ', Date: ' || v_payment.paymentDate || 
                             ', Status: ' || v_payment.Status || 
                             ', Patient ID: ' || v_payment.PatientID || 
                             ', Doctor ID: ' || v_payment.DoctorID);
    END LOOP;
    CLOSE c_payments;
END report_payments;
