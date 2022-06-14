namespace OneLogin {
    public class APIAccessToken
    {
        public string access_token {get; set;}
        public string account_id {get; set;}
        public DateTimeOffset? created_at {get; set;}
        public DateTimeOffset? expires_at
        {
            get
            {
                return this.created_at.Value.AddSeconds(this.expires_in);
            }
        }
        public int expires_in {get; set;}
        public string refresh_token {get; set;}
        public string token_type {get; set;}
    }
}