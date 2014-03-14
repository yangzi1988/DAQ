% Takes the users input for the compensation enables and allows the
% controls for them
function enable_compensations(hObject, eventdata, handles)

DAQ_constants_include;

    % Must ensure that DAQ has been initialized otherwise handles.xem will
    % not yet be defined
    if (daq_initialized == 1)
        % Obtaining the enable states
        cs = get(handles.enable_comp_cslow,'Value');
        cf = get(handles.enable_comp_cfast,'Value');
        rs = get(handles.enable_comp_rseries,'Value');
        su = get(handles.enable_comp_supercharge,'Value');

        % Gating the available controls

            % Vector of enable states
                v = [cs cf rs su];

            % Cslow 
                if(isequal(v,[1 0 0 0]))
                    set(handles.enable_comp_cslow,'Enable','on');
                    set(handles.enable_comp_cfast,'Enable','on');
                    set(handles.enable_comp_rseries,'Enable','on');
                    set(handles.enable_comp_supercharge,'Enable','on');

                    set(handles.edit_Cfast,'Enable','off');
                    set(handles.edit_Cslow,'Enable','on');
                    set(handles.edit_Rseries,'Enable','off');
                    set(handles.edit_Rs_comp,'Enable','off');
                    set(handles.edit_Supercharge,'Enable','off');

            % Cslow & Super
                elseif(isequal(v,[1 0 0 1]))
                    set(handles.enable_comp_cslow,'Enable','on');
                    set(handles.enable_comp_cfast,'Enable','on');
                    set(handles.enable_comp_rseries,'Enable','on');
                    set(handles.enable_comp_supercharge,'Enable','on');

                    set(handles.edit_Cfast,'Enable','off');
                    set(handles.edit_Cslow,'Enable','on');
                    set(handles.edit_Rseries,'Enable','off');
                    set(handles.edit_Rs_comp,'Enable','off');
                    set(handles.edit_Supercharge,'Enable','on');


            % Cfast
                elseif(isequal(v,[0 1 0 0]))
                    set(handles.enable_comp_cslow,'Enable','on');
                    set(handles.enable_comp_cfast,'Enable','on');
                    set(handles.enable_comp_rseries,'Enable','off');
                    set(handles.enable_comp_supercharge,'Enable','off');

                    set(handles.edit_Cfast,'Enable','on');
                    set(handles.edit_Cslow,'Enable','off');
                    set(handles.edit_Rseries,'Enable','off');
                    set(handles.edit_Rs_comp,'Enable','off');
                    set(handles.edit_Supercharge,'Enable','off');

            % Cfast & Cslow
                elseif(isequal(v,[1 1 0 0]))
                    set(handles.enable_comp_cslow,'Enable','on');
                    set(handles.enable_comp_cfast,'Enable','on');
                    set(handles.enable_comp_rseries,'Enable','on');
                    set(handles.enable_comp_supercharge,'Enable','on');

                    set(handles.edit_Cfast,'Enable','on');
                    set(handles.edit_Cslow,'Enable','on');
                    set(handles.edit_Rseries,'Enable','off');
                    set(handles.edit_Rs_comp,'Enable','off');
                    set(handles.edit_Supercharge,'Enable','off');

            % Cfast & Cslow & Super
                elseif(isequal(v,[1 1 0 1]))
                    set(handles.enable_comp_cslow,'Enable','on');
                    set(handles.enable_comp_cfast,'Enable','on');
                    set(handles.enable_comp_rseries,'Enable','on');
                    set(handles.enable_comp_supercharge,'Enable','on');

                    set(handles.edit_Cfast,'Enable','on');
                    set(handles.edit_Cslow,'Enable','on');
                    set(handles.edit_Rseries,'Enable','off');
                    set(handles.edit_Rs_comp,'Enable','off');
                    set(handles.edit_Supercharge,'Enable','on');         

            % Rseries & Cslow
                elseif(isequal(v,[1 0 1 0]))
                    set(handles.enable_comp_cslow,'Enable','on');
                    set(handles.enable_comp_cfast,'Enable','on');
                    set(handles.enable_comp_rseries,'Enable','on');
                    set(handles.enable_comp_supercharge,'Enable','on');

                    set(handles.edit_Cfast,'Enable','off');
                    set(handles.edit_Cslow,'Enable','on');
                    set(handles.edit_Rseries,'Enable','on');
                    set(handles.edit_Rs_comp,'Enable','on');
                    set(handles.edit_Supercharge,'Enable','off');          

            % Rseries & Cslow & Super
                elseif(isequal(v,[1 0 1 1]))
                    set(handles.enable_comp_cslow,'Enable','on');
                    set(handles.enable_comp_cfast,'Enable','on');
                    set(handles.enable_comp_rseries,'Enable','on');
                    set(handles.enable_comp_supercharge,'Enable','on');

                    set(handles.edit_Cfast,'Enable','off');
                    set(handles.edit_Cslow,'Enable','on');
                    set(handles.edit_Rseries,'Enable','on');
                    set(handles.edit_Rs_comp,'Enable','on');
                    set(handles.edit_Supercharge,'Enable','on');  

              % Rseries & Cslow & Cfast 
                elseif(isequal(v,[1 1 1 0]))
                    set(handles.enable_comp_cslow,'Enable','on');
                    set(handles.enable_comp_cfast,'Enable','on');
                    set(handles.enable_comp_rseries,'Enable','on');
                    set(handles.enable_comp_supercharge,'Enable','on');

                    set(handles.edit_Cfast,'Enable','on');
                    set(handles.edit_Cslow,'Enable','on');
                    set(handles.edit_Rseries,'Enable','on');
                    set(handles.edit_Rs_comp,'Enable','on');
                    set(handles.edit_Supercharge,'Enable','off');           

             % Rseries & Cslow & Cfast & Super
                elseif(isequal(v,[1 1 1 1]))
                    set(handles.enable_comp_cslow,'Enable','on');
                    set(handles.enable_comp_cfast,'Enable','on');
                    set(handles.enable_comp_rseries,'Enable','on');
                    set(handles.enable_comp_supercharge,'Enable','on');

                    set(handles.edit_Cfast,'Enable','on');
                    set(handles.edit_Cslow,'Enable','on');
                    set(handles.edit_Rseries,'Enable','on');
                    set(handles.edit_Rs_comp,'Enable','on');
                    set(handles.edit_Supercharge,'Enable','on');       


            % All other cases        
                else
                    set(handles.enable_comp_cslow,'Enable','on');
                    set(handles.enable_comp_cfast,'Enable','on');
                    set(handles.enable_comp_rseries,'Enable','on');
                    set(handles.enable_comp_supercharge,'Enable','off');

                    set(handles.edit_Cfast,'Enable','off');
                    set(handles.edit_Cslow,'Enable','off');
                    set(handles.edit_Rseries,'Enable','off');
                    set(handles.edit_Rs_comp,'Enable','off');
                    set(handles.edit_Supercharge,'Enable','off');

                    set(handles.enable_comp_cslow,'Value',0);
                    set(handles.enable_comp_cfast,'Value',0);
                    set(handles.enable_comp_rseries,'Value',0);
                    set(handles.enable_comp_supercharge,'Value',0);

                end



            % Update DACs and DPOTs
            DAQ_updateDAC(handles);
            DAQ_updateDPOT(handles);

    end

end


