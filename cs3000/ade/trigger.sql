use ade;

-- Trigger

DROP TRIGGER IF EXISTS patient_after_update_pregnant;

DELIMITER //

CREATE TRIGGER patient_after_update_pregnant
	AFTER UPDATE ON patient
	FOR EACH ROW
BEGIN

    -- Patient became pregnant
    -- Add pre-natal recommenation
    -- Delete any prescriptions that shouldn't be taken if pregnant
     if  new.is_pregnant = 1 and old.is_pregnant = 0  then
 
                
        INSERT INTO  recommendation 
				( patient_id ,
				 message )
				VALUES
				(new.patient_id,
				'Take pre-natal vitamins.');
        
        DELETE prescription
		 from  prescription
		inner JOIN  patient ON patient.patient_id = prescription.patient_id 
	    inner JOIN  medication  ON medication.medication_id = new.patient_id 
              where patient.patient_id = new.patient_id   
              and   medication.take_if_pregnant = 0  ;
     end if;
     
     

    -- Patient is no longer pregnant
    -- Remove pre-natal recommendation
  if  new.is_pregnant = 0 and old.is_pregnant = 1  then
        DELETE  
        from recommendation
          where patient_id = new.patient_id   
                and message = 'Take pre-natal vitamins.'  ;
 
     end if;

END //
