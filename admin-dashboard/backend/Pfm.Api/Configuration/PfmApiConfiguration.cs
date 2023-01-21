namespace Pfm.Api.Configuration
{
    public class PfmApiConfiguration
    {
        public KeycloakConfiguration KeycloakConfiguration { get; set; }
        public string[] AllowedCorsOrigin { get; set; }
    }
}
