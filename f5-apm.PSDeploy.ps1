Deploy f5-apm {

    By FileSystem {
        FromSource '.\'
        To 'C:\Program Files\WindowsPowerShell\Modules\f5-apm'
        Tagged Prod
    }
}