Deploy f5-apm {

    By FileSystem {
        FromSource '.\f5-apm'
        To 'C:\Program Files\WindowsPowerShell\Modules\f5-apm'
        Tagged Prod
    }
}