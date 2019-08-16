FROM microsoft/iis
SHELL ["powershell"]

RUN Install-WindowsFeature NET-Framework-472-ASPNET ; \
    Install-WindowsFeature Web-Asp-Net472

WORKDIR /inetpub/wwwroot
COPY src src

RUN powershell -NoProfile -Command Remove-Item -Recurse C:\inetpub\wwwroot\*

WORKDIR /inetpub/wwwroot
COPY src src
COPY nginx.conf nginx.conf
COPY run.sh run.sh

RUN msbuild src/Benchmarks.build.proj /t:Clean
RUN msbuild src/Benchmarks.build.proj /t:Build

CMD bash run.sh
