namespace OneLogin {
    
    public class Authentication {

        public string id {get;set;}
        public int device_id {get;set;}
        public int user_id {get;set;}
        public string user_display_name {get;set;}
        public string type_display_name {get;set;}
        public string auth_factor_name {get;set;}
        public DateTimeOffset? expires_at {get;set;}
        public Device Device {get;set;}
        public string Status {get;set;}
    }

}
