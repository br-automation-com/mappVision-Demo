// INIT
// Common action  (hwInstance[], hmiInstance[] and localInstance[] as the pointers always will point to the last index
ACTION userInitCommonPreAction: 

END_ACTION

// Local run for each idx action (use hw, this and hmi as they point to the current array index) 
ACTION userInitLocalPostAction: 

END_ACTION


// EXECUTE
// Common action brefore all other (hwInstance[], hmiInstance[] and localInstance[] as the pointers always will point to the last index 
ACTION userCommonPreAction: 

END_ACTION

// Common action after all other (hwInstance[], hmiInstance[] and localInstance[] as the pointers always will point to the last index
ACTION userCommonPostAction: 

END_ACTION

// Local run for each idx action before all other (use hw, this and hmi as they point to the current array index) 
ACTION userLocalPreAction: 

END_ACTION


// Local run for each idx action after all other (use hw, this and hmi as they point to the current array index) 
ACTION userLocalPostAction: 

END_ACTION


// Local action that is called after the standard vision result processing is done. 
ACTION userResultProcessingAction: 

END_ACTION

// EXIT
// Common action (hwInstance[], hmiInstance[] and localInstance[] as the pointers always will point to the last index 
ACTION userExitCommonPostAction: 

END_ACTION

// Local run for each idx action (use hw, this and hmi as they point to the current array index) 
ACTION userExitLocalPostAction: 

END_ACTION


