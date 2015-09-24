# PuppetServer

#### Tabela de conteudo

1. [Overview](#overview)
2. [Compatibilidade](#compatibilidade)
3. [Setup](#setup)
4. [Uso](#uso)
5. [Limites](#limites)
6. [Pendende](#pendente)
7. [Referencias](#referencias)

## Overview

Esse módulo instala e configura o Puppet Server do Puppet 4.2 em ambiente CentOS.

## Compatibilidade

Esse módulo é compatível com CentOS >= 7

Esse módulo foi escrito usando recursos do Puppet 4.x.

## Setup

### O que esse modulo gerencia?

#### classe puppetserver

  * Repositório yum PC1 da Puppetlabs (yumrepo)
  * Arquivo /etc/hosts (file)
  * Arquivo /etc/hostname (file)
  * Hostname do sevidor (hostnamectl sethostname) (exec)
  * Ajusta o path para usar os binários do Puppet 4.2 (file)
  * Gera o master CA (exec)
  * Gera o certificado do puppetserver (exec)
  * Gerencia o arquivo /etc/sysconfig/puppetserver (template)
  * Ajusta o arquivo /etc/puppetlabs/puppet/puppet.conf (exec)

## Uso

### declarando classe mcollective

```puppet
  class { ::puppetserver:
    server_ipaddr => '192.168.200.150',
    server_hostid => 'puppetserver',
    server_domain => 'hacklab',
    jvm_heap_mem  => '512m',
    jvm_perm_mem  => '512m',
    start_timeout => '300'
  }
```

## Limites

  1. Só funciona em CentOS 7
  2. Só funciona com Puppet 4.2
  3. Testando apenas com Puppet Server 2.1.1

## Pendente

  1. Gerenciar Puppet Agent

## Referencias

  * http://gutocarvalho.net/octopress/2015/08/18/instalando-puppet-4-agent-and-master/
