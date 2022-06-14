namespace OneLogin {

    public enum Region {
        US,
        EU
    }

    public class Connection {

        private string ClientID;

        private string ClientSecret;

        public Region Region {get;set;}

        public string BaseURL {get;set;}

        public Hashtable Headers {get;set;}

        public APIRateLimit RateLimit  {get;set;}

        public APIAccessToken AccessToken {get;set;}

        public Connection (string ClientID, string ClientSecret, Region Region) {
            this.ClientID = ClientID;
            this.ClientSecret = ClientSecret;
            this.Region = Region;
            this.BaseURL = "https://api." + Region + ".onelogin.com";
        }

    }

}