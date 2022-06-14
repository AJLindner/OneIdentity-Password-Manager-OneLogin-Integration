namespace OneLogin {
    public class APIRateLimit
    {

        public int RateLimit {get; set;}
        public int RateLimitRemaining {get; set;}
        public TimeSpan RateLimitReset {get; set;}

        public APIRateLimit (int RateLimit, int RateLimitRemaining, int RateLimitReset)
        {
            this.RateLimit = RateLimit;
            this.RateLimitRemaining = RateLimitRemaining;
            this.RateLimitReset = new TimeSpan(0, 0, RateLimitReset);
        }
    }
}