function [correction] = ClockCorrection(station_correction,date,station_data,kk,matFile)
               
        % input kk is the index for station need to be corrected.
                       
        jour = str2num(date(7:8));
        mois = str2num(date(5:6));
        an = str2num(date(1:4));
        
        duration = datenum(an,mois,jour) - datenum(2011,12,1);
             
        ista1 = find(strcmp(station_correction(kk),station_data));
        if  (isempty(ista1) == 0)
            sta_name =  station_data;
                        
            ista = 0;
            
            if (sum(sta_name == 'PF01') == 4)
                ista = 1;
            elseif (sum(sta_name == 'PF03') == 4)
                ista = 2;
            elseif (sum(sta_name == 'PF06') == 4)
                ista = 3;
            elseif (sum(sta_name == 'PF09') == 4)
                ista = 4;
            elseif (sum(sta_name == 'PF12') == 4)
                ista = 5;
            elseif (sum(sta_name == 'PF15') == 4)
                ista = 6;
            end
            
            tshift_cor = matFile.clock.dti(duration,ista);
            correction = -1*tshift_cor;
        end
        
    end
