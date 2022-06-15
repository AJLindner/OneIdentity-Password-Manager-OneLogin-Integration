namespace OneLogin {

    public class Connection {

        private string ClientID;

        private string ClientSecret;

        public string Subdomain {get;set;}

        public string BaseURL {get;set;}

        public Hashtable Headers {get;set;}

        public APIRateLimit RateLimit  {get;set;}

        public APIAccessToken AccessToken {get;set;}

        public Connection (string ClientID, string ClientSecret, String Subdomain) {
            this.ClientID = ClientID;
            this.ClientSecret = ClientSecret;
            this.Subdomain = Subdomain;
            this.BaseURL = "https://" + Subdomain + ".onelogin.com";
        }

    }

}