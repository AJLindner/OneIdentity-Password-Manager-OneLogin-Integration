namespace OneLogin {

    public enum UserStatus
    {
        Unactivated = 0,
        Active = 1,
        Suspended = 2,
        Locked = 3,
        Password_Expired = 4,
        Awaiting_Password_Reset = 5,
        Unknown = 6,
        Password_Pending = 7,
        Security_Questions_Required = 8
    }

    public enum UserState {
        Unapproved = 1,
        Approved = 2,
        Rejected = 3,
        Unlicensed = 4
    }


    public class User {
       
        public DateTimeOffset? activated_at { get; set; }
        public string comment { get; set; }
        public string company { get; set; }
        public DateTimeOffset? created_at { get; set; }
        public Hashtable custom_attributes { get; set; }
        public string department { get; set; }
        public string directory_id {get; set;}
        public string distinguished_name {get; set;}
        public string email {get; set;}
        public string external_id {get; set;}
        public string firstname {get; set;}
        public string group_id {get; set;}
        public string id {get; set;}
        public string invalid_login_attempts {get; set;}
        public DateTimeOffset? invitation_sent_at {get; set;}
        public string lastname {get; set;}
        public DateTimeOffset? last_login {get; set;}
        public string locale_code {get; set;}
        public string preferred_locale_code {get; set;}
        public DateTimeOffset? locked_until {get; set;}
        public string manager_ad_id {get; set;}
        public string manager_user_id {get; set;}
        public string member_of {get; set;}
        public string notes {get; set;}
        public string openid_name {get; set;}
        public DateTimeOffset? password_changed_at {get; set;}
        public string phone {get; set;}
        public string[] role_ids {get; set;}
        public string samaccountname {get; set;}
        public UserState state {get; set;}
        public UserStatus status {get; set;}
        public string title {get; set;}
        public string trusted_idp_id {get; set;}
        public DateTimeOffset? updated_at {get; set;}
        public string username {get; set;}
        public string userprincipalname {get; set;}

        public override string ToString() { return this.id; }
    }


}