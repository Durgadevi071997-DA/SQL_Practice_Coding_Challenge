-- create a data base

create database hospital;
Use Hospital;

create table patients(
   Patient_id int,
   Patient_Name varchar(20),
   Age int,
   Gender Enum('M','F'),
   Admission_Date date
   );
   
   alter table patients
   add  DoctorAssigned VARCHAR(50);
   
   alter table patients
   modify patient_Name varchar(100);
   
   -- rename 
   rename table patients to patients_info;
   

   TRUNCATE TABLE Patients_info;
   
   DROP TABLE Patients_info;
   

   
   