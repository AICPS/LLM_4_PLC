DATA_BLOCK "ArmData"
VAR
state: Int;
prevState: Int;
xpos: Int;
ypos: Int;
holding: Bool;
impulse1_prev_h: Bool;
impulse2_prev_h: Bool;
impulse1_prev_v: Bool;
impulse2_prev_v: Bool;
targetXpos: Int;
targetYpos: Int;
END_VAR
BEGIN
state := 5;
prevState := -1;
xpos := 0;
ypos := 0;
holding := FALSE;
impulse1_prev_h := FALSE;
impulse2_prev_h := FALSE;
impulse1_prev_v := FALSE;
impulse2_prev_v := FALSE;
targetXpos := 0;
targetYpos := 0;
END_DATA_BLOCK

ORGANIZATION_BLOCK "ArmLogic"
VAR CONSTANT
IDLE_STATE: Int := 0;
MOVE_TO_TARGET: Int := 1;
EXTEND_ARM: Int := 2;
LIFT_COMPONENT: Int := 3;
RETRACT_ARM: Int := 4;
RETURN_HOME: Int := 5;
PLACE_COMPONENT: Int := 6;
END_VAR
BEGIN
// Encoder Logic
IF ("HB HORIZ REF SWITCH") THEN
    "ArmData".xpos := 0;
END_IF;
IF ("HB VERT REF SWITCH") THEN
    "ArmData".ypos := 0;
END_IF;
IF ("HB HORIZ IMPULSE1" AND NOT "ArmData".impulse1_prev_h) AND NOT "HB HORIZ IMPULSE2" THEN
    "ArmData".xpos := "ArmData".xpos - 1;
ELSIF ("HB HORIZ IMPULSE2" AND NOT "ArmData".impulse2_prev_h) AND NOT "HB HORIZ IMPULSE1" THEN
    "ArmData".xpos := "ArmData".xpos + 1;
END_IF;

IF ("HB VERT IMPULSE1" AND NOT "ArmData".impulse1_prev_v) AND NOT "HB VERT IMPULSE2" THEN
    "ArmData".ypos := "ArmData".ypos - 1;
ELSIF ("HB VERT IMPULSE2" AND NOT "ArmData".impulse2_prev_v) AND NOT "HB VERT IMPULSE1" THEN
    "ArmData".ypos := "ArmData".ypos + 1;
END_IF;

"ArmData".impulse1_prev_h := "HB HORIZ IMPULSE1";
"ArmData".impulse2_prev_h := "HB HORIZ IMPULSE2";
"ArmData".impulse1_prev_v := "HB VERT IMPULSE1";
"ArmData".impulse2_prev_v := "HB VERT IMPULSE2";
// Main Logic
CASE "ArmData".state OF
    #IDLE_STATE:
        IF "RED BTN" AND NOT "ArmData".holding THEN
            "ArmData".targetXpos := 1315;
            "ArmData".targetYpos := 405;
            "ArmData".state := #MOVE_TO_TARGET;
        ELSIF "BLACK BTN" AND NOT "ArmData".holding THEN
            "ArmData".targetXpos := 734;
            "ArmData".targetYpos := 760;
            "ArmData".state := #MOVE_TO_TARGET;
        END_IF;

    #MOVE_TO_TARGET:
        // Move in the X direction
        IF "ArmData".xpos < "ArmData".targetXpos THEN
            "HB HORIZ MOTOR POS" := TRUE;
            "HB HORIZ MOTOR NEG" := FALSE;
        ELSE
            "HB HORIZ MOTOR POS" := FALSE;
            "HB HORIZ MOTOR NEG" := FALSE;
        END_IF;

        // Move in the Y direction
        IF "ArmData".ypos < "ArmData".targetYpos THEN
            "HB VERT MOTOR POS" := TRUE;
            "HB VERT MOTOR NEG" := FALSE;
        ELSE
            "HB VERT MOTOR POS" := FALSE;
            "HB VERT MOTOR NEG" := FALSE;
        END_IF;

        // Check if arm reached the target position
        IF "ArmData".xpos >= "ArmData".targetXpos AND "ArmData".ypos >= "ArmData".targetYpos THEN
            "ArmData".state := #EXTEND_ARM;
        END_IF;

    #EXTEND_ARM:
        "HB MOTOR ARM FRONT" := TRUE;
        "HB MOTOR ARM BACK" := FALSE;
        IF "HB ARM REF FRONT" = 1 THEN
            "ArmData".state := #LIFT_COMPONENT;
            "HB MOTOR ARM FRONT" := FALSE;
            "ArmData".targetYpos := "ArmData".targetYpos - 40;
        END_IF;

    #LIFT_COMPONENT:
        // Lift logic
        "HB VERT MOTOR NEG" := TRUE;
        "HB VERT MOTOR POS" := FALSE;
        IF "ArmData".ypos <= "ArmData".targetYpos THEN
            "HB VERT MOTOR NEG" := FALSE;
            "ArmData".state := #RETRACT_ARM;
        END_IF;

    #RETRACT_ARM:
        "HB MOTOR ARM FRONT" := FALSE;
        "HB MOTOR ARM BACK" := TRUE;
        IF "HB ARM REF BACK" = 1 THEN
            "ArmData".state := #RETURN_HOME;
            "HB MOTOR ARM BACK" := FALSE;
        END_IF;

    #RETURN_HOME:
        // Logic to return the arm to its home position
        "HB VERT MOTOR NEG" := NOT "HB VERT REF SWITCH";
        "HB HORIZ MOTOR NEG" := NOT "HB HORIZ REF SWITCH";
        IF "HB VERT REF SWITCH" AND "HB HORIZ REF SWITCH" THEN
            "ArmData".state := #IDLE_STATE;
        END_IF;

    #PLACE_COMPONENT:
        // Logic to place the component
        "ArmData".state := #IDLE_STATE;
END_CASE;

END_ORGANIZATION_BLOCK