FROM microsoft/iis
SHELL ["powershell"]
RUN mkdir C:\site 
ENV chocolateyUseWindowsCompression false
RUN powershell Get-DnsClientServerAddress
RUN Set-DnsClientServerAddress -InterfaceIndex 5 -ServerAddresses ('8.8.8.8') ; \
    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')); \
    Install-WindowsFeature -Name Web-Asp-Net45; \ 
    Install-WindowsFeature -Name Web-AppInit; \
    Install-WindowsFeature -Name Web-Http-Tracing; \
    Install-WindowsFeature -Name Web-Mgmt-Service; \
	#Install-WindowsFeature -Name Web-Net-Ext; \
	Install-WindowsFeature -Name Web-Server; \
    Install-WindowsFeature -Name Web-WebSockets; \
    Install-WindowsFeature -Name Web-Dyn-Compression; \
    Install-WindowsFeature -Name Web-Custom-Logging; \
    Install-WindowsFeature -Name Web-Request-Monitor; \
    choco install "dotnet4.6.2" --version "4.6.01590.20170129" -yf; \
    webpicmd.exe /install /products:AdvancedLogging /accepteula /suppresseboot  ;\
    webpicmd.exe /install /products:ASPNET_REGIIS_NET45 /accepteula /suppressreboot  ;\
    choco install urlrewrite --version 2.0.20160209 -yf --checksum='154a645dd10a9b22bf52ad161bac5199d284d5ec' --checksum64='6a98b994adcc2e8d21507bf2b8baffb402c17395'  ;\
    choco install iis-externalcache --version 1.1.20151123 -yf --checksum='77a28bd68a0a51981eeb37ba39632831bd7d9a59' --checksum64='e408df20ee6aa202c7bc3771a4f5a97d2bfc52bf'  ;\
    choco install iis-arr --version 3.0.20160107 -yf --checksum='69bd0a5fb2a9f9cbed3a5cb1a4ca429698610d07' --checksum64='5f4f24058dcd675da46dc0c4b17969d41fce68c1'  

#IIS configuration

RUN Remove-WebSite -Name 'Default Web Site'  
RUN New-Website -Name 'site' -Port 8000 -PhysicalPath 'c:\site' -ApplicationPool '.NET v4.5'

#EXPOSE 8000
#ADD src/JE.Api.RestaurantMenu/bin /site


