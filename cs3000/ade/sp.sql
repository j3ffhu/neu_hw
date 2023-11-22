 

use ade;



-- A stored procedure to process and validate prescriptions
-- Four things we need to check
-- a) Is patient a child and is medication suitable for children?
-- b) Is patient pregnant and is medication suitable for pregnant women?
-- c) Are there any adverse drug reactions


drop procedure if exists prescribe;

delimiter //
create procedure prescribe
(
    in patient_name_param varchar(255),
    in doctor_name_param varchar(255),
    in medication_name_param varchar(255),
    in ppd_param int -- pills per day prescribed
)
begin
	-- variable declarations
    declare patient_id_var int;
    declare age_var float;
    declare is_pregnant_var boolean;
    declare weight_var int;
    declare doctor_id_var int;
    declare medication_id_var int;
    declare take_under_12_var boolean;
    declare take_if_pregnant_var boolean;
    declare mg_per_pill_var double;
    declare max_mg_per_10kg_var double;

    declare message varchar(255); -- The error message
    declare ddi_medication varchar(255); -- The name of a medication involved in a drug-drug interaction

    -- select relevant values into variables
    select patient_id,  timestampdiff(YEAR, dob, NOW() ) , is_pregnant, weight
    into patient_id_var, age_var, is_pregnant_var, weight_var
    from patient
    where patient_name_param = patient_name;
    
   select doctor_id
    into  doctor_id_var
    from   doctor
    where doctor.doctor_name = doctor_name_param;
    
    select  medication_id
    into  medication_id_var
    from   medication 
    where medication.medication_name = medication_name_param;
    
     select  medication_id , take_under_12, take_if_pregnant, mg_per_pill,  max_mg_per_10kg
      into medication_id_var, take_under_12_var, take_if_pregnant_var, mg_per_pill_var , max_mg_per_10kg_var
      from medication
      where  medication_name = medication_name_param;
    
  
    -- check age of patient
		IF  age_var < 12 and take_under_12_var = 0  THEN 
           set  message   = concat (medication_name_param,  ' cannot be prescribed to children under 12 '  );
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = message ;
		END IF;

    -- check if medication ok for pregnant women
		IF  is_pregnant_var = 1 and take_if_pregnant_var = 0  THEN 
           set  message   = concat (medication_name_param,  ' cannot be prescribed to pregnant women.'  );
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = message ;
		END IF;

    -- Check for reactions involving medications already prescribed to patient
     select interaction.medication_1 
     into ddi_medication
		 from prescription 
		 inner join interaction on prescription.medication_id = interaction.medication_1
		 where  prescription.patient_id =  patient_id_var
		  and prescription.doctor_id = doctor_id_var
          and prescription.patient_id = patient_id_var
		  and interaction.medication_2 = medication_id_var
            LIMIT 1;
    
          
      IF ddi_medication is not null then
             set  message   = concat (medication_name_param,  ' interacts with ' ,  ddi_medication, ' currently prescribed to  ' , patient_name_param);
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = message ;
		END IF;

 
    -- No exceptions thrown, so insert the prescription record
		INSERT INTO  prescription 
		(medication_id,
		patient_id,
		doctor_id,
		prescription_dt,
		ppd)
		VALUES
		(medication_id_var,
		patient_id_var,
		doctor_id_var,
		now(),
		ppd_param);

end //
delimiter ;
