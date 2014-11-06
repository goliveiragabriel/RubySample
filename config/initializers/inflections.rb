# encoding: utf-8
# Be sure to restart your server when you modify this file.
# Add new inflection rules using the following format
# (all these examples are active by default):
ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
    inflect.irregular 'recomendação', 'recomendações'
    inflect.singular 'história', 'histórias'
    inflect.singular 'dia', 'dias'
    inflect.singular 'ponto', 'pontos'
    inflect.singular 'amigo', 'amigos'
    inflect.singular 'convidado', 'convidados'
    inflect.irregular 'fornecedor', 'fornecedores'

end
