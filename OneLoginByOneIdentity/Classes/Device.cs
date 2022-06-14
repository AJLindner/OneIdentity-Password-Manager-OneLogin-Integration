namespace OneLogin {
    
    public class Device {
        public int device_id {get;set;}
        public string user_display_name {get;set;}
        public string type_display_name {get;set;}
        public string auth_factor_name {get;set;}
        public bool is_default {get;set;}
        public User user {get;set;}
        public string verification_method {
            get {
                return AuthFactor.GetVerificationMethod(this.auth_factor_name);
            }
        }
    }

    public class AuthFactor {
        public static Hashtable verification_methods = new Hashtable(){
            // OneLogin Protect App Push Authentication
            {"OneLogin","Prompt"},

            // OneLogin Voice
            {"OneLogin Voice","Prompt"},

            // OneLogin SMS
            {"SMS","OTP"},

            // OneLogin Authenticator OTP Code
            {"Google Authenticator","OTP"},

            // OneLogin Email
            {"OneLogin Email","Both"},

        };
        public int factor_id {get;set;}

        public string name {get;set;}

        public string auth_factor_name {get;set;}

        public string verification_method {
            get {
                return AuthFactor.GetVerificationMethod(this.auth_factor_name);
            }
        }

        public static string GetVerificationMethod (string AuthType) {
            return (string) AuthFactor.verification_methods[AuthType];
        }
    }

    public class DeviceRegistration {
        public string id {get;set;}
        public string status {get;set;}
        public string auth_factor_name {get;set;}
        public string type_display_name {get;set;}
        public string user_display_name {get;set;}
        public string device_id {get;set;}
        public DateTimeOffset? expires_at {get;set;}
        public Hashtable factor_data {get;set;}
        public User user {get;set;}
        public AuthFactor authFactor {get;set;}

    }


}