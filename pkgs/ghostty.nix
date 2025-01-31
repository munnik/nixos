{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "modbus-cli";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "simonvetter";
    repo = "modbus";
    rev = "v${version}";
    hash = "sha256-od0+icEBoIchsOF0dL1V0ynmJgoBBavJQTqe3mabCT8=";
  };

  vendorHash = "sha256-81BslhZgYWb8xaEWZLGx0p8tlYJ7YeYWb9yhqe7skvM=";

  doCheck = false; # tests fail
  ldflags = [
    "-s"
    "-w"
  ];

  subPackages = [ "cmd" ];
  postInstall = ''
    mv $out/bin/cmd $out/bin/modbus-cli
  '';

  CGO_ENABLED = 0;

  meta = with lib; {
    description = "Go Modbus library and client";
    homepage = "https://github.com/simonvetter/modbus";
    license = licenses.mit;
    maintainers = with maintainers; [ simonvetter ];
    platforms = platforms.linux;
  };
}
