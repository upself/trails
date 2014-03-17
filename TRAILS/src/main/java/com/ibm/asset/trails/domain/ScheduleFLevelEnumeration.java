package com.ibm.asset.trails.domain;

public enum ScheduleFLevelEnumeration {

	PRODUCT,HWOWNER,HWBOX,HOSTNAME;

	public String value() {
		return name();
	}

	public static ScheduleFLevelEnumeration fromValue(String v) {
		return valueOf(v);
	}
	
    public static boolean contains(String name){   
         
    	ScheduleFLevelEnumeration[] level = values();   
        
       for(ScheduleFLevelEnumeration l : level){   
           if(l.name().equals(name)){   
               return true;   
           }   
       }   
   
       return false;   
    }  

}