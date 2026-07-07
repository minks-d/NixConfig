{...}:
{
  services.pulseaudio.daemon.config = {
    default-sample-rate = 48000;
    alternate-sample-rate = 44100;
    default-fragments = 2;
  };
}
