################################################################################
# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

# ============== Common methods ==============

require 'json'

def pretty(arg)
  return puts arg if arg.instance_of?(String)
  puts JSON.pretty_generate(arg)
end

# Removes quotes from nil and false values
def data_parse(data = {})
  data = resource['data'] ||= data
  data.each do |key, value|
    data[key] = nil if value == 'nil'
    data[key] = false if value == 'false'
    data[key] = true if value == 'true'
    data[key] = data[key].to_i if key == 'vlanId'
  end
  data
end

# FIXME: method created because data_parse (above) was returning hashes with booleans as strings
# to be debugged in the future
def data_parse_interconnect(data)
  data.each do |key, value|
    data[key] = nil if value == 'nil'
    data[key] = false if value == 'false'
    data[key] = true if value == 'true'
    data[key] = data[key].to_i if key == 'vlanId'
  end
  data
end

def resource_update(data, resourcetype)
  current_resource = resourcetype.find_by(@client, name: data['name']).first
  current_resource ? current_attributes = current_resource.data : return
  new_name_validation(data, resourcetype)
  raw_merged_data = current_attributes.merge(data)
  updated_data = Hash[raw_merged_data.to_a - current_attributes.to_a]
  current_resource.update(updated_data) unless updated_data.empty?
end

def new_name_validation(data, resourcetype)
  # Validation for name change on resource through flag 'new_name'
  if data['new_name']
    new_resource_name_used = resourcetype.find_by(@client, name: data['new_name']).first
    data['name'] = data['new_name'] unless new_resource_name_used
    data.delete('new_name')
  end
end

def objectfromstring(str)
  # capitalizing the first letter + getting the remaining ones as they are
  # '.capitalize' alone will return something like Firstlettercapitalizedonly
  Object.const_get("OneviewSDK::#{str.to_s[0].upcase}#{str[1..str.size]}")
end

# Returns a resource's unique identifier (name or uri)
def unique_id
  raise(Puppet::Error, 'Must set resource name or uri before trying to retrieve it!') if !@data['name'] && !@data['uri']
  id = {}
  if @data['name']
    id.merge!(name: @data['name'])
  else
    id.merge!(uri: @data['uri'])
  end
end
