classdef MicrogridStatus < Simulink.IntEnumType
    % Copyright 2023-2024 The MathWorks, Inc.
    % MATLAB enumeration class definition generated from template
    %   to track the active leaf state of RemoteMicrogrid/Diesel Substation, BESS, & Microgrid Controller/Microgrid Controller/Microgrid Supervisory Control/Transition and Dispatch Control.
    
    enumeration
        None(0),
		Steady_State_Islanded(1),
		Resynchronization(2),
		Steady_State_Grid_Connected(3),
		Planned_Islanding(4),
		Unplanned_Islanding(5)
    end

    methods (Static)

        function defaultValue = getDefaultValue()
            % GETDEFAULTVALUE  Returns the default enumerated value.
            %   If this method is not defined, the first enumeration is used.
            defaultValue = MicrogridStatus.None;
        end

        function dScope = getDataScope()
            % GETDATASCOPE  Specifies whether the data type definition should be imported from,
            %               or exported to, a header file during code generation.
            dScope = 'Auto';
        end

        function desc = getDescription()
            % GETDESCRIPTION  Returns a description of the enumeration.
            desc = 'enumeration to track active leaf state of RemoteMicrogrid/Diesel Substation, BESS, & Microgrid Controller/Microgrid Controller/Microgrid Supervisory Control/Transition and Dispatch Control';
        end

        function fileName = getHeaderFile()
            % GETHEADERFILE  Returns path to header file if non-empty.
            fileName = '';
        end

        function flag = addClassNameToEnumNames()
            % ADDCLASSNAMETOENUMNAMES  Indicate whether code generator applies the class name as a prefix
            %                          to the enumeration.
            flag = true;
        end

    end

end
